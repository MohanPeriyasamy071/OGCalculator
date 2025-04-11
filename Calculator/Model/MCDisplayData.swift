//
//  DisplayData.swift
//  Calculator
//
//  Created by Mohan Periyasamy on 25/01/25.
//

import Foundation
import SwiftUICore
import SwiftUI

enum MCButton : String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case add = "+"
    case subtract = "-"
    case multiply = "x"
    case divide = "÷"
    case equal = "="
    case clear = "AC"
    case decimal = "."
    case percent = "%"
    case negative = "+/-"
    
    var buttonColor: Color {
        switch self {
        case .add, .subtract, .multiply, .divide, .equal:
            return .teal
        case .clear, .percent , .negative:
            return Color(.darkGray)
        default :
            return Color(UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1))
        }
    }
}

enum MCOperator : String {
    case add = "+",subtract = "-" ,multiply = "x" ,divide = "÷", none
}

var buttons : [[MCButton]] = [
[.clear, .negative, .percent, .divide],
[.seven, .eight, .nine, .multiply],
[.four, .five, .six, .subtract],
[.one, .two, .three, .add],
[.zero, .decimal, .equal],
]

func buttonHeight(button : MCButton) -> CGFloat {
    if button == .zero {
        return ((UIScreen.main.bounds.width - (4*12)) / 4) * 2
    }
    return (UIScreen.main.bounds.width - (5*12)) / 4
}
func buttonWidth(button : MCButton) -> CGFloat {
    return (UIScreen.main.bounds.width - (5*12)) / 4
}
