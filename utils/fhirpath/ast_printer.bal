// FHIRPath AST Printer - prints expression in Lisp-like format

public function printAst(Expr expr) returns string {
    if expr is BinaryExpr {
        return parenthesize(expr.operator.lexeme, expr.left, expr.right);
    } else if expr is LiteralExpr {
        if expr.value is () {
            return "nil";
        }
        return expr.value.toString();
    } else if expr is IdentifierExpr {
        return expr.name;
    } else if expr is FunctionExpr {
        string result = "(" + expr.name;
        foreach Expr param in expr.params {
            result += " " + printAst(param);
        }
        result += ")";
        return result;
    } else if expr is MemberAccessExpr {
        return parenthesize(".", expr.target, createIdentifierExpr(expr.member));
    } else {
        // IndexerExpr
        return parenthesize("[]", expr.target, expr.index);
    }
}

function parenthesize(string name, Expr... exprs) returns string {
    string result = "(" + name;

    foreach Expr expr in exprs {
        result += " " + printAst(expr);
    }

    result += ")";
    return result;
}

