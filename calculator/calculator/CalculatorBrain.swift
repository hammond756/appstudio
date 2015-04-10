//
//  CalculatorBrain.swift
//  calculator
//
//  Created by Aron Hammond on 09/04/15.
//  Copyright (c) 2015 mprog. All rights reserved.
//
//  Aron Hammond - 10437215

import Foundation

class CalculatorBrain: Printable
{
    // collection of different types of Ops
    private enum Op: Printable
    {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case SpecialOperation(String, Double)
//        case Variable(String)
//        case setVariable(String, String -> String)
        
        var description: String
        {
            get
            {
                switch self
                {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .SpecialOperation(let symbol, _):
                    return symbol
//                case .Variable(let symbol):
//                    return symbol
//                case .setVariable(let symbol, _):
//                    return symbol
                }
            }
        }
    }
    
    // private data structures used in CalculatorBrain
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    
//    var variableValues = [String:Double]()
    
    init()
    {
        // function to add new operations to knownOps
        func learnOp(op: Op)
        {
            knownOps[op.description] = op
        }
        
        // list of operations, more can be added
        learnOp(Op.BinaryOperation("×") {$0 * $1})
        learnOp(Op.BinaryOperation("÷")  {$1 / $0})
        learnOp(Op.BinaryOperation("+")  {$0 + $1})
        learnOp(Op.BinaryOperation("−")  {$1 - $0})
        learnOp(Op.UnaryOperation("√") { sqrt($0) })
        learnOp(Op.UnaryOperation("cos") { cos($0) } )
        learnOp(Op.UnaryOperation("sin") { sin($0) } )
        learnOp(Op.SpecialOperation("🍰", M_PI))
    }
    
    // recursive function evaluate the opStack
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty
        {
            // copy the opStack for manipulation
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op
            {
            // just return operands
            case .Operand(let operand):
                return (operand, remainingOps)
            // evaluate all that's needed to preform the unary operation
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result
                {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            // evaluate both sides of the binary operation
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result
                {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result
                    {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            // return value corresponding to constant symbol
            case .SpecialOperation(_, let operand):
                return (operand, remainingOps)
//            case .Variable(let symbol):
//                if let value = variableValues[symbol]
//                {
//                    return (value, remainingOps)
//                }
//            case .setVariable(let symbol):
//                self.variableValues[
//                evaluate(remainingOps)
            }
        }
        
        // failure
        return (nil, ops)
    }
    
    // main function for evaluation, but action is in helper function above
    func evaluate() -> Double?
    {
        let (result, remainder) = evaluate(opStack)
        return result
    }
    
    // push the value to the stack
    func pushOperand(operand: Double) -> Double?
    {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    
//    func pushOperand(symbol: String) -> Double?
//    {
//        opStack.append(Op.Variable(symbol))
//        
//        if variableValues[symbol] == nil
//        {
//            variableValues[symbol] = 0
//        }
//        
//        return evaluate()
//    }
    
    // add corresponding operation to opStack
    func preformOperation(symbol: String) -> Double?
    {
        if let operation = knownOps[symbol]
        {
            opStack.append(operation)
        }
        
        return evaluate()
    }
    
    // clear opStack
    func clearMemory()
    {
        opStack = []
    }
    
    // recursive helper function for describe
    private func print(content: [Op]) -> (element: String?, remaining: [Op])
    {
        // functions for the conversion of a binary and unary operation
        func printUnaryExpression(type: String, expression: String) -> String
        {
            return ("\(type)" + "(" + expression + ")")
        }
        func printBinaryExpression(type: String, expr1: String, expr2: String) -> String
        {
            return (expr2 + type + expr1)
        }
        
        if !content.isEmpty
        {
            // make a copy of the opStack
            var contentCopy = content
            let op = contentCopy.removeLast()
            
            switch op
            {
            // just return any operand (along with contentCopy for recursion)
            case .Operand(let operand):
                return ("\(operand)", contentCopy)
            // prints out the symbol of the operation with the appropriate expression in parentheses (using recusrion)
            case .UnaryOperation(let operation, _):
                let printOperand = print(contentCopy)
                if let operand = printOperand.element
                {
                    return (printUnaryExpression(operation, operand), contentCopy)
                }
            // firgure out what goes on both sides of the symbol (by recursion)
            case .BinaryOperation(let operation, _):
                let printOpsRight = print(contentCopy)
                if var opsRight = printOpsRight.element
                {
                    // insert parentheses around an element if needed
                    if contentCopy.count - printOpsRight.remaining.count > 2
                    {
                        opsRight = "(" + opsRight + ")"
                    }
                    let printOpsLeft = print(printOpsRight.remaining)
                    if let opsLeft = printOpsLeft.element
                    {
                        return (printBinaryExpression(operation, opsRight, opsLeft), printOpsLeft.remaining)
                    }
                }
            // return the symbol corresponding with constant value
            case .SpecialOperation(let operand, _):
                return (operand, contentCopy)
//            case .Variable(let symbol):
//                return (symbol, contentCopy)
//            case .setVariable(let symbol):
//                return (symbol, contentCopy)
            }
        }
        
        return ("?", content)

    }
    
    // function that prints out a preformed operation in readable format
    var description: String
    {
        get
        {
            let (content, _) = print(opStack)
            if let printableContent = content
            {
            return content!
            }
            else
            {
                return "Unable to evaluate opStack"
            }
        }
        
    }
}