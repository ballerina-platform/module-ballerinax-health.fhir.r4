#!/usr/bin/env python3
# Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
#
# WSO2 LLC. licenses this file to you under the Apache License,
# Version 2.0 (the "License"); you may not use this file except
# in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

"""Converts a FHIR XML resource to FHIR JSON using StructureDefinitions for types and cardinality.

Usage: fhir_xml2json.py <definitions-dir> <input.xml>   (writes JSON to stdout)
Decimal values are emitted with their original text so their precision is preserved.
"""
import json
import sys
import xml.etree.ElementTree as ET

NS = "{http://hl7.org/fhir}"
XHTML = "{http://www.w3.org/1999/xhtml}"
FHIR_TYPE_EXT = "http://hl7.org/fhir/StructureDefinition/structuredefinition-fhir-type"
NUMBER_TYPES = {"integer", "positiveInt", "unsignedInt", "integer64"}


class RawNumber(float):
    """A number whose JSON text is kept verbatim (e.g. 1.0, 0.010)."""
    def __new__(cls, text):
        obj = float.__new__(cls, float(text))
        obj.text = text
        return obj


def load_model(defs_dir):
    elements = {}  # parent path/type -> {name: (types, repeats, contentRef)}
    kinds = {}
    for f in ("profiles-types.json", "profiles-resources.json"):
        for entry in json.load(open(f"{defs_dir}/{f}"))["entry"]:
            sd = entry["resource"]
            if sd.get("resourceType") != "StructureDefinition" or sd.get("derivation") == "constraint":
                continue
            kinds[sd["id"]] = sd["kind"]
            for el in sd["snapshot"]["element"]:
                path = el["path"]
                if "." not in path:
                    continue
                parent, child = path.rsplit(".", 1)
                types = []
                for t in el.get("type", []):
                    code = t["code"]
                    for ext in t.get("extension", []):
                        if ext.get("url") == FHIR_TYPE_EXT:
                            code = ext["valueUrl"]
                    types.append(code.rsplit(".", 1)[-1] if code.startswith("http://hl7.org/fhirpath/") else code)
                repeats = el.get("max", "1") not in ("0", "1")
                ref = el.get("contentReference", "")[1:] or None
                elements.setdefault(parent, {})[child] = (types, repeats, ref)
    return elements, kinds


def local(tag):
    return tag.split("}", 1)[1] if "}" in tag else tag


def lookup(model, key, xml_name):
    """Returns (json_name, type, repeats, child_key) for an XML child element."""
    children = model[0].get(key, {})
    if xml_name in children:
        types, repeats, ref = children[xml_name]
        if ref:
            return xml_name, "BackboneElement", repeats, ref
        t = types[0] if types else "string"
        child_key = f"{key}.{xml_name}" if f"{key}.{xml_name}" in model[0] else t
        return xml_name, t, repeats, child_key
    for base, (types, repeats, _) in children.items():
        if base.endswith("[x]") and xml_name.startswith(base[:-3]):
            suffix = xml_name[len(base) - 3:]
            for t in types:
                if t[:1].upper() + t[1:] == suffix:
                    return xml_name, t, repeats, t
    return xml_name, None, None, None  # unknown element (e.g. logical models)


def convert_value(t, text):
    if t == "boolean":
        return text == "true"
    if t in NUMBER_TYPES:
        return int(text)
    if t == "decimal":
        return RawNumber(text)
    return text


def convert_element(model, node, key):
    obj = {}
    if node.get("id") is not None and key not in model[1]:
        obj["id"] = node.get("id")
    if node.get("url") is not None:
        obj["url"] = node.get("url")
    grouped = {}
    for child in node:
        if not isinstance(child.tag, str):
            continue
        name = local(child.tag)
        if child.tag.startswith(XHTML):
            # Narrative.div holds the XHTML as a string
            obj["div"] = ET.tostring(child, encoding="unicode").replace("ns0:", "").replace(":ns0", "")
            continue
        grouped.setdefault(name, []).append(child)
    for name, nodes in grouped.items():
        json_name, t, repeats, child_key = lookup(model, key, name)
        if repeats is None:
            repeats = len(nodes) > 1
        values, primitive_elements, is_primitive = [], [], False
        for n in nodes:
            if t in model[1] and model[1].get(t) == "resource" or (t in ("Resource", "DomainResource")):
                inner = [c for c in n if isinstance(c.tag, str)][0]
                values.append(convert_resource(model, inner))
                continue
            if t is not None and t[:1].islower() and t != "xhtml" or (t is None and n.get("value") is not None and len(n) == 0):
                is_primitive = True
                value = n.get("value")
                values.append(convert_value(t, value) if value is not None else None)
                extra = convert_element(model, n, t or "string")
                extra.pop("url", None)
                primitive_elements.append(extra or None)
            else:
                values.append(convert_element(model, n, child_key or name))
        obj[json_name] = values if repeats else values[0]
        if is_primitive and any(primitive_elements):
            obj["_" + json_name] = primitive_elements if repeats else primitive_elements[0]
            if all(v is None for v in values):
                del obj[json_name]
    return obj


def convert_resource(model, node):
    rtype = local(node.tag)
    out = {"resourceType": rtype}
    out.update(convert_element(model, node, rtype))
    return out


def dumps(value):
    if isinstance(value, RawNumber):
        return value.text
    if isinstance(value, dict):
        return "{" + ", ".join(json.dumps(k) + ": " + dumps(v) for k, v in value.items()) + "}"
    if isinstance(value, list):
        return "[" + ", ".join(dumps(v) for v in value) + "]"
    return json.dumps(value)


if __name__ == "__main__":
    ET.register_namespace("", "http://www.w3.org/1999/xhtml")
    model = load_model(sys.argv[1])
    root = ET.parse(sys.argv[2]).getroot()
    sys.stdout.write(dumps(convert_resource(model, root)) + "\n")
