//
//  ViewController.swift
//  calculator
//
//  Created by Aron Hammond on 01/04/15.
//  Copyright (c) 2015 mprog. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

    @IBOutlet weak var display: UILabel!
    
    var userIsTypingNumber: Bool = false

    @IBAction func appendDigit(sender: UIButton)
    {
        let digit = sender.currentTitle!
        
        if userIsTypingNumber
        {
            display.text = display.text! + digit
        }
        else
        {
            userIsTypingNumber = true
        }
    }
}

