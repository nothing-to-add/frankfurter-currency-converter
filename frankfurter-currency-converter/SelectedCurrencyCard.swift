//
//  File name: SelectedCurrencyCard.swift
//  Project name: frankfurter-currency-converter
//  Workspace name: frankfurter-currency-converter
//
//  Created by: nothing-to-add on 30/06/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import SwiftUI

struct SelectedCurrencyCard: View {
    let selectedCurrency: Currency?
    @Binding var amount: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(selectedCurrency?.code ?? "Code")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .transition(.opacity)
                    .animation(.easeInOut, value: selectedCurrency?.code)
                Text(CurrencyDescription().getDescription(for: selectedCurrency ?? Currency(code: "None", rate: 0.0)))
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .transition(.opacity)
                    .animation(.easeInOut, value: selectedCurrency?.code)
            }
            
            Spacer()
            
            TextField("Enter amount", text: $amount)
                .multilineTextAlignment(.trailing)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .frame(maxWidth: 150)
                .foregroundStyle(.teal)
                .font(.title2)
        }
        .padding()
        .background(Color(.teal))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding()
    }
}
