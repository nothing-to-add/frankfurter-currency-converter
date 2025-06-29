//
//  File name: CurrencyCard.swift
//  Project name: frankfurter-currency-converter
//  Workspace name: frankfurter-currency-converter
//
//  Created by: nothing-to-add on 30/06/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import SwiftUI

struct CurrencyCard: View {
    let currency: Currency
    let selectedCurrency: Currency?
    let currencyValue: String
    var onTap: (() -> Void)
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(currency.code)
                    .font(.headline)
                Text(CurrencyDescription().getDescription(for: currency))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(currencyValue)
                    .font(.headline)
                    .transition(.opacity)
                    .animation(.easeInOut, value: currencyValue)
                Text(String(format: "1 \(selectedCurrency?.code ?? "") = %.2f", currency.rate))
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .transition(.opacity)
                    .animation(.easeInOut, value: currency.rate)
            }
            .padding(0)
        }
        .listRowSeparator(.hidden)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .contentShape(Rectangle())
        .opacity(currency.code == selectedCurrency?.code ?? "" ? 0 : 1)
        .animation(.easeInOut, value: selectedCurrency?.code)
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    CurrencyCard(currency: Currency(code: "USD", rate: 1.0),
                 selectedCurrency: Currency(code: "EUR", rate: 0.85),
                 currencyValue: "100",
                 onTap: {})
}
