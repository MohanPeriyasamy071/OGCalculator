//
//  CalculatorView.swift
//  Calculator
//
//  Created by Mohan Periyasamy on 25/01/25.
//

import SwiftUI

struct MCCalculatorView: View {
    @EnvironmentObject var userData: MCUserData
    @AppStorage("userPasscode") private var userPasscode: String = "1234"
    @State var result: String = "0"
    @State var userInputData: String = ""
    @State var isPasscodeScreenPresented: Bool = false
    @State var shouldShowUserInputData : Bool = false
    @State var currentOperator : MCOperator = .none
    @State var previousOperator : MCOperator = .none
    @State var operatingValue : Double = 0
    @State var isCalculated : Bool = false
    @State var shouldShowHiddenAlbum : Bool = false
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            if shouldShowHiddenAlbum {
                MCHiddenAlbumView(shouldShowHiddenAlbum: $shouldShowHiddenAlbum)
            }
            else if isPasscodeScreenPresented {
                MCChangePasscode(isPasscodeScreenPresented: $isPasscodeScreenPresented)
            }
            else {
                VStack {
                    Spacer()
                    VStack {
                        if shouldShowUserInputData {
                            HStack {
                                Spacer()
                                Text(userInputData)
                                    .font(.system(size: 32, weight: .medium, design: .monospaced))
                                    .foregroundColor(.white)
                            }
                            
                        }
                        HStack {
                            Spacer()
                            Text(result)
                                .font(.system(size: 80, design: .default))
                                .foregroundColor(.white)
                        }
                        .padding()
                    }
                    
                    ForEach (buttons ,id: \.self) { row in
                        HStack(spacing: 12) {
                            ForEach (row , id: \.hashValue) { button in
                                Button(action : {
                                    mcHandleTap(button: button)
                                },
                                       label: {
                                    Text(button.rawValue)
                                        .foregroundColor(.white)
                                        .font(.system(size: CGFloat(32)))
                                        .frame(
                                            width: buttonHeight(button: button),
                                            height: buttonWidth(button: button),
                                            alignment: .center
                                        )
                                        .background(button.buttonColor)
                                        .cornerRadius(buttonWidth(button: button)/2)
                                }
                                )
                                
                            }
                        }
                        .padding(.bottom, 3)
                    }
                }
            }
        }
    }
    
    func mcHandleTap(button : MCButton) {
        var isSameOperator : Bool = false
        if (button != .clear  && button != .equal && button != .negative) {
            userInputData = "\(userInputData)\(button.rawValue)"
        }
        if userInputData == userPasscode {
            userInputData = ""
            result = "0"
            shouldShowHiddenAlbum = true
            return
        }
        if userInputData == "+\(userPasscode)" {
            userInputData = ""
            result = "0"
            isPasscodeScreenPresented = true
            return
        }
        if (button == .add  || button == .subtract || button == .multiply || button == .divide) {
            if let lastChar = userInputData.last {
                if let lastLastChar = String(userInputData.dropLast()).last {
                    if String(lastChar) ==  String(lastLastChar) {
                        userInputData = String(userInputData.dropLast())
                        isSameOperator = true
                    }
                    
                    else if (String(lastLastChar) == MCOperator.add.rawValue || String(lastLastChar) == MCOperator.subtract.rawValue || String(lastLastChar) == MCOperator.multiply.rawValue || String(lastLastChar) == MCOperator.divide.rawValue) &&  (String(lastChar) == MCOperator.add.rawValue || String(lastChar) == MCOperator.subtract.rawValue || String(lastChar) == MCOperator.multiply.rawValue || String(lastChar) == MCOperator.divide.rawValue){
                        userInputData = String(userInputData.dropLast())
                        userInputData = String(userInputData.dropLast())
                        userInputData = "\(userInputData)\(button.rawValue)"
                        isSameOperator = true
                        if let status = MCOperator(rawValue: String(lastChar)) {
                            previousOperator = status
                            currentOperator = status
                        } else {
                            
                        }
                    }
                }
            }
        }
        
        if !isSameOperator {
            switch button {
            case .add, .subtract, .multiply, .divide, .equal:
                shouldShowUserInputData = true
                if button == .add {
                    currentOperator = .add
                    
                    switch previousOperator {
                    case .add:
                        result = String((Double(operatingValue)) + (Double(result) ?? 0.0))
                    case .subtract:
                        result = String((Double(operatingValue)) - (Double(result) ?? 0.0))
                    case .multiply:
                        result = String((Double(operatingValue)) * (Double(result) ?? 0.0))
                    case .divide:
                        result = String((Double(operatingValue)) / (Double(result) ?? 0.0))
                    default :
                        break
                    }
                    
                    previousOperator = .add
                    operatingValue = Double(result) ?? 0.0
                }
                else if button == .subtract {
                    currentOperator = .subtract
                    switch previousOperator {
                    case .add:
                        result = String((Double(operatingValue)) + (Double(result) ?? 0.0))
                    case .subtract:
                        result = String((Double(operatingValue)) - (Double(result) ?? 0.0))
                    case .multiply:
                        result = String((Double(operatingValue)) * (Double(result) ?? 0.0))
                    case .divide:
                        result = String((Double(operatingValue)) / (Double(result) ?? 0.0))
                    default :
                        break
                    }
                    
                    previousOperator = .subtract
                    operatingValue = Double(result) ?? 0.0
                }
                else if button == .multiply {
                    currentOperator = .multiply
                    switch previousOperator {
                    case .add:
                        result = String((Double(operatingValue)) + (Double(result) ?? 0.0))
                    case .subtract:
                        result = String((Double(operatingValue)) - (Double(result) ?? 0.0))
                    case .multiply:
                        result = String((Double(operatingValue)) * (Double(result) ?? 0.0))
                    case .divide:
                        result = String((Double(operatingValue)) / (Double(result) ?? 0.0))
                    default :
                        break
                    }
                    
                    previousOperator = .multiply
                    operatingValue = Double(result) ?? 0.0
                }
                else if button == .divide {
                    currentOperator = .divide
                    switch previousOperator {
                    case .add:
                        result = String((Double(operatingValue)) + (Double(result) ?? 0.0))
                    case .subtract:
                        result = String((Double(operatingValue)) - (Double(result) ?? 0.0))
                    case .multiply:
                        result = String((Double(operatingValue)) * (Double(result) ?? 0.0))
                    case .divide:
                        result = String((Double(operatingValue)) / (Double(result) ?? 0.0))
                    default :
                        break
                    }
                    
                    previousOperator = .divide
                    operatingValue = Double(result) ?? 0.0
                }
                else if button == .equal {
                    switch currentOperator {
                    case .add:
                        result = String((Double(operatingValue)) + (Double(result) ?? 0.0))
                    case .subtract:
                        result = String((Double(operatingValue)) - (Double(result) ?? 0.0))
                    case .multiply:
                        result = String((Double(operatingValue)) * (Double(result) ?? 0.0))
                    case .divide:
                        result = String((Double(operatingValue)) / (Double(result) ?? 0.0))
                    default :
                        break
                    }
                    previousOperator = .none
                    currentOperator = .none
                }
                isCalculated = true

            case .clear:
                shouldShowUserInputData = false
                result = "0"
                userInputData = ""
                operatingValue = 0
                currentOperator = .none
                previousOperator = .none
                
            case .decimal, .negative, .percent:
                result = "SYNTAX ERROR!"
                
            case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero:
                if result == "0" || isCalculated {
                    result = button.rawValue
                    isCalculated = false
                }
                else {
                    result = result + "\(button.rawValue)"
                }
            }
        }
       
       if result.split(separator: ".").count > 1 {
           if result.split(separator: ".")[1] == "0" {
               result = String(result.split(separator: ".").first ?? "")
           }
        }
    }
}



