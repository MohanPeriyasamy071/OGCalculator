//
//  MCChangePasscode.swift
//  Calculator
//
//  Created by Mohan Periyasamy on 26/01/25.
//

import SwiftUI

struct MCChangePasscode: View {
    @AppStorage("userPasscode") private var userPasscode: String = "1234"
    @Binding var isPasscodeScreenPresented: Bool
    @State private var passcode = ""
    @FocusState private var isFocused: Bool
    @State private var confirmPasscode = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var closePage = false

    var body: some View {
        NavigationView{
            
            VStack {
                Spacer()
                
                SecureField("Enter Passcode", text: $passcode)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .focused($isFocused)  //
                    .frame(width: 300)
            
                SecureField("Confirm Passcode", text: $confirmPasscode)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .frame(width: 300)
                
                Spacer()
                
                Button(action: {
                    validatePasscode()
                }) {
                    Text("Change Passcode")
                        .padding()
                        .frame(maxWidth: 300)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
               
          
            }
            .safeAreaInset(edge: .top) {
                HStack {
                    Button(action: {
                        isPasscodeScreenPresented = false
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Cancel")
                        }
                    }
                    Spacer()
           
                }
             
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    
                    isPasscodeScreenPresented = false
                }
            }
        }
        .navigationTitle("Change Passcode")
        .navigationBarTitleDisplayMode(.inline)
       
        .onAppear {
            DispatchQueue.main.async {
                isFocused = true
            }
        }
        .alert("Passcode Change", isPresented: $showAlert) {
            Button("OK", role: .cancel) {
                if closePage {
                    isPasscodeScreenPresented = false
                }
            }
        } message: {
            Text(alertMessage)
        }
    }

    private func validatePasscode() {
        if passcode.isEmpty || confirmPasscode.isEmpty {
            alertMessage = "Passcode fields cannot be empty!"
        } else if passcode == confirmPasscode {
            if passcode == userPasscode {
                alertMessage = "Passcode should be different from the current one!"
            } else {
                alertMessage = "Passcode changed successfully!"
                userPasscode = passcode
                closePage = true
            }
        } else {
            alertMessage = "Passcode and Confirm Passcode do not match!"
        }
        showAlert = true
    }
}




