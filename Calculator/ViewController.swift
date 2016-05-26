//
//  ViewController.swift
//  Calculator
//
//  Created by Biying Bai on 21/5/16.
//  Copyright © 2016 Biying Bai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var userIsInTheMiddleOfTyping=false
    private var displayValue:Double{
        get{
            return Double(display.text!)!
        }
        set{
            display.text=String(newValue)
        }
    }
    
    private var brain=CalculatorBrain()
    @IBOutlet private weak var display: UILabel!
    @IBAction private func touchDigit(sender: UIButton) {
        let digit=sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay=display.text!
            display.text=textCurrentlyInDisplay+digit
        }
        else{
            display.text=digit
        }
        userIsInTheMiddleOfTyping=true
    }
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
           brain.setOperand(displayValue)
           userIsInTheMiddleOfTyping=false
        }
        if let mathematicalSymbol=sender.currentTitle{
          brain.performOperation(mathematicalSymbol)
            displayValue=brain.result
         }
    }
    var saveProgram:AnyObject?
    @IBAction func save() {
        saveProgram=brain.program
    }
    @IBAction func restore() {
        if(saveProgram != nil){
            brain.program=saveProgram!
            displayValue=brain.result
        }
    }
}

