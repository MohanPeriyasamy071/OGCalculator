//
//  CalculatorApp.swift
//  Calculator
//
//  Created by Mohan Periyasamy on 25/01/25.
//

import SwiftUI
import SwiftData

@main
struct CalculatorApp: App {
    @StateObject private var userData = MCUserData()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MCCalculatorView()
                .environmentObject(userData)
        }
        .modelContainer(sharedModelContainer)
    }
}
