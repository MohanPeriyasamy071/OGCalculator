//
//  MCUserData.swift
//  Calculator
//
//  Created by Mohan Periyasamy on 26/01/25.
//

import Foundation

class MCUserData: ObservableObject, Equatable {
    static func == (lhs: MCUserData, rhs: MCUserData) -> Bool {
        return lhs.userPasscode == rhs.userPasscode
    }
    
    @Published var userPasscode: String = "1234"
}
