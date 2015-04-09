//
//  CalculatorBrain.swift
//  calculator
//
//  Created by Aron Hammond on 09/04/15.
//  Copyright (c) 2015 mprog. All rights reserved.
//

import Foundation

class CalculatorBrain: Printable
{
    private enum Op: Printable
    {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
//        case Variable(String)
        
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
//                case .Variable(let symbol):
//                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    
//    var variableValues = [String:Double]()
//    
//    private var waitingForValue = false
    
    init()
    {
        knownOps["×"] = Op.BinaryOperation("×")  {$0 * $1}
        knownOps["÷"] = Op.BinaryOperation("÷")  {$1 / $0}
        knownOps["+"] = Op.BinaryOperation("+")  {$0 + $1}
        knownOps["−"] = Op.BinaryOperation("−")  {$1 - $0}
        knownOps["√"] = Op.UnaryOperation("√") { sqrt($0) }
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty
        {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op
            {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result
                {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
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
//            case .Variable(let symbol):
//                if let value = variableValues[symbol]
//                {
//                    return (value, remainingOps)
//                }
            }
        }
        
        return (nil, ops)
    }
    
    func evaluate() -> Double?
    {
        let (result, remainder) = evaluate(opStack)
        // println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
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
    
    func preformOperation(symbol: String) -> Double?
    {
        if let operation = knownOps[symbol]
        {
            opStack.append(operation)
        }
        
        return evaluate()
    }
    
    func clearMemory()
    {
        opStack = []
    }
    
    private func print(content: [Op]) -> (element: String?, remaining: [Op])
    {
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
            var contentCopy = content
            var expressions = [String]()
            let op = contentCopy.removeLast()
            
            switch op
            {
            case .Operand(let operand):
                return ("\(operand)", contentCopy)
            case .UnaryOperation(let operation, _):
                let printOperand = print(contentCopy)
                if let operand = printOperand.element
                {
                    return (printUnaryExpression(operation, operand), contentCopy)
                }
            case .BinaryOperation(let operation, _):
                let printOpsRight = print(contentCopy)
                if var opsRight = printOpsRight.element
                {
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
            }
        }
        
        return ("?", content)

    }
    
    
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