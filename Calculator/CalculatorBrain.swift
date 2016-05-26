//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Biying Bai on 21/5/16.
//  Copyright © 2016 Biying Bai. All rights reserved.
//

import Foundation

class CalculatorBrain{
    private var accumulator=0.0
    private var pending:PendingBinaryOperationInfo?
    typealias PropertyList=AnyObject
    private var internalProgram=[AnyObject]()
    private var operations:Dictionary<String,Operation>  = ["pi":Operation.Constant(M_PI),
        "e":Operation.Constant(M_E),
        "✔️": Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation (cos),
        "x": Operation.BinaryOperation({$0*$1}),
        "➗": Operation.BinaryOperation({$0/$1}),
        "+": Operation.BinaryOperation({$0+$1}),
        "-": Operation.BinaryOperation({$0-$1}),
        "=": Operation.Equals
    ]
    var result:Double{
        get{
            return accumulator
        }
    }
    var program: PropertyList{
        get{
            return internalProgram
        }
        set{
            clear()
            if let arrayOfOps=newValue as? [AnyObject]{
                for op in arrayOfOps{
                    if let operand=op as? Double{
                        setOperand(operand)
                    }
                    else if let operation=op as? String{
                        performOperation(operation)
                    }
                }
            }
        }
    }
    func clear(){
        accumulator=0.0
        pending=nil
        internalProgram.removeAll()
    }
    private enum Operation{
        case Constant(Double)
        case UnaryOperation((Double)->Double)
        case BinaryOperation((Double,Double)->Double)
        case Equals
    }
    private struct PendingBinaryOperationInfo{
        var binaryFunction:(Double,Double)->Double
        var firstOperand:Double
    }
    func setOperand(operand:Double){
        accumulator=operand
        internalProgram.append(operand)
    }
    private func executePendingBinaryOperation(){
        if(pending != nil){
            accumulator=pending!.binaryFunction(pending!.firstOperand,accumulator)
            pending=nil
        }
    }
    func performOperation(symbol:String){
        internalProgram.append(symbol)
        if let operation=operations[symbol]{
            switch(operation){
              case .Constant (let value): accumulator=value
              case .UnaryOperation (let function): accumulator=function(accumulator)
              case .BinaryOperation (let function):
                   executePendingBinaryOperation()
                   pending=PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                
              case .Equals: executePendingBinaryOperation()
            }
        }
    }
}
