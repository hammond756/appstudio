//
//  ViewController.swift
//  calculator
//
//  Created by Aron Hammond on 02/04/15.
//  Copyright (c) 2015 mprog. All rights reserved.
//

import UIKit
import Darwin

class ViewController: UIViewController
{
    
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var log: UILabel!
    
    var userIsTyping = false
    var isDoingOperation = false
    var numberTyped = ""
    
    @IBAction func appendDigit(sender: UIButton)
    {
        let digit = sender.currentTitle!
        
        
        if userIsTyping
        {
            display.text = display.text! + digit
            numberTyped = numberTyped + digit
        }
        else
        {
            display.text = digit
            userIsTyping = true
            numberTyped = digit
        }
    }
    
    @IBAction func operate(sender: UIButton)
    {
        let operation = sender.currentTitle!
        
        if userIsTyping
        {
            enter()
        }
        
        switch operation
        {
        case "×": preformOperation {$0 * $1} 
        case "÷": preformOperation {$1 / $0}
        case "+": preformOperation {$0 + $1}
        case "−": preformOperation {$1 - $0}
        case "√": preformOperation { sqrt($0) }
        case "π":
            operandStack.append(M_PI)
            display.text = "\(M_PI)"
        case "cos": preformOperation { cos($0) }
        case "sin": preformOperation { sin($0) }
        default: break
        }
        
        log.text = log.text! + operation + ", "
    }
    
    func preformOperation(operation: (Double, Double) -> Double)
    {
        if operandStack.count >= 2
        {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    func preformOperation(operation: Double -> Double)
    {
        if operandStack.count >= 2
        {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    var numberIsFloat = false
    
    @IBAction func point(sender: UIButton)
    {
        if numberIsFloat == false
        {
            display.text = display.text! + sender.currentTitle!
            numberIsFloat = true
        }
    }
    
    @IBAction func clear()
    {
        display.text = "0"
        operandStack = []
        log.text = ""
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enter()
    {
        userIsTyping = false
        numberIsFloat = false
        operandStack.append(displayValue)
        
        
        
        if numberTyped != ""
        {
            log.lineBreakMode = NSLineBreakMode.ByTruncatingTail
            log.text = log.text! + numberTyped + ", "
            numberTyped = ""
        }
        

    }
    
    var displayValue: Double
    {
        get
        {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set
        {
            display.text = "\(newValue)"
            userIsTyping = false
        }
    }
    
}

