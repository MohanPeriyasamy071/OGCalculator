//
//  Item.swift
//  Calculator
//
//  Created by Mohan Periyasamy on 25/01/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
