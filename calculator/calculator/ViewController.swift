//
//  ViewController.swift
//  calculator
//
//  10437215
//
//  Created by Aron Hammond on 02/04/15.
//  Copyright (c) 2015 mprog. All rights reserved.
//
// bug: in landscape mode verdwijnt het dispaly label. Heb dit niet kunnen verhelpen

import UIKit
import Darwin

class ViewController: UIViewController
{
    // connect outlets
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var log: UILabel!
    
    // declare variables for checking states and storing numbers
    var userIsTyping = false
    var isDoingOperation = false
    var numberTyped = ""
    
    // link to number buttons
    @IBAction func appendDigit(sender: UIButton)
    {
        let digit = sender.currentTitle!
        
        // print number on screen and save to numberTyped for logging
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
    
    // link to the operators
    @IBAction func operate(sender: UIButton)
    {
        let operation = sender.currentTitle!
        
        // shortcut for user experience
        if userIsTyping
        {
            enter()
        }
        
        // preform required operation on operandStack
        switch operation
        {
        case "×": preformOperation {$0 * $1} 
        case "÷": preformOperation {$1 / $0}
        case "+": preformOperation {$0 + $1}
        case "−": preformOperation {$1 - $0}
        case "√": preformOperation { sqrt($0) }
        // exception: pi is added to stack and shown in display
        case "π":
            operandStack.append(M_PI)
            display.text = "\(M_PI)"
        case "cos": preformOperation { cos($0) }
        case "sin": preformOperation { sin($0) }
        default: break
        }
        
        // add the operator to the log
        log.text = log.text! + operation + ", "
    }
    
    // compute the result for two operands and store in displayValue
    func preformOperation(operation: (Double, Double) -> Double)
    {
        if operandStack.count >= 2
        {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    // compute the result for one operands and store in displayValue
    func preformOperation(operation: Double -> Double)
    {
        if operandStack.count >= 2
        {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    // boolean for checking amount of points typed
    var numberIsFloat = false
    
    // link to the point
    @IBAction func point(sender: UIButton)
    {
        // only insert point if it is the first
        if numberIsFloat == false
        {
            display.text = display.text! + sender.currentTitle!
            numberIsFloat = true
        }
    }
    
    // link to C button. Sets calculator to original state
    @IBAction func clear()
    {
        display.text = "0"
        operandStack = []
        log.text = ""
    }
    
    // array for holding operands
    var operandStack = Array<Double>()
    
    // link to 'enter' button
    @IBAction func enter()
    {
        // user is not typing and check for float is reset
        userIsTyping = false
        numberIsFloat = false
        // add number on screen to stack
        operandStack.append(displayValue)
        
        // if number is not yet added to log, add it
        if numberTyped != ""
        {
            log.lineBreakMode = NSLineBreakMode.ByTruncatingHead
            log.text = log.text! + numberTyped + ", "
            numberTyped = ""
        }
    }
    
    // variable to easily change and retrieve the value on screen as a Double
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

