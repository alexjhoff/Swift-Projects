//
//  StructEnums.swift
//  Calculator
//
//  Created by Alex Hoff on 6/28/17.
//  Copyright © 2017 Alex Hoff. All rights reserved.
//

import Foundation

enum Operator: String{
    case add = "+"
    case subtract = "-"
    case times = "*"
    case divide = "/"
    case nothing = ""
}

enum CalculationState: String{
    case enteringNum = "enteringNum"
    case newNumStarted = "newNumStarted"
}
