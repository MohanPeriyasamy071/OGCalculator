//
//  SecurePhoto.swift
//  Calculator
//
//  Created by Mohan Periyasamy on 26/01/25.
//


import SwiftUI


struct SecurePhoto: Identifiable, Equatable {
    let id: UUID
    let image: UIImage
    let assetIdentifier: String?
    
    static func == (lhs: SecurePhoto, rhs: SecurePhoto) -> Bool {
        lhs.id == rhs.id
    }
}

