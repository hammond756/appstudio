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
    
    // add the brain
    var brain = CalculatorBrain()
    
    // link to number buttons
    @IBAction func appendDigit(sender: UIButton)
    {
        let digit = sender.currentTitle!
        
        // print number on screen and save to numberTyped for logging
        if userIsTyping
        {
            display.text = display.text! + digit
        }
        else
        {
            display.text = digit
            userIsTyping = true
        }
    }
    
    // link to the operators
    @IBAction func operate(sender: UIButton)
    {
        // shortcut for user experience
        if userIsTyping
        {
            enter()
        }
        
        // tell the brain to preform selected operation
        if let operation = sender.currentTitle
        {
            if let result = brain.preformOperation(operation)
            {
                displayValue = result
                log.text = brain.description
            }
            else
            {
                displayValue = nil
            }
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
        brain.clearMemory()
        display.text = "0"
        log.text = ""
    }
    
    // link to 'enter' button
    @IBAction func enter()
    {
        // user is not typing and check for float is reset
        userIsTyping = false
        numberIsFloat = false
        
        // add number on screen to stack
        if let result = brain.pushOperand(displayValue!)
        {
            displayValue = result
            log.text = brain.description

        }
        else
        {
            displayValue = nil
        }
        
    }
    
    // variable to easily change and retrieve the value on screen as a Double
    var displayValue: Double?
    {
        get
        {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set
        {
            // clear display if result is non-computable)
            if newValue == nil
            {
                display.text = " "
            }
            else
            {
                display.text = "\(newValue!)"
            }
            userIsTyping = false
        }
    }
}

