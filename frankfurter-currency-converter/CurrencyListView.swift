//
//  File name: CurrencyListView.swift
//  Project name: frankfurter-currency-converter
//  Workspace name: frankfurter-currency-converter
//
//  Created by: nothing-to-add on 19/04/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import SwiftUI

struct CurrencyListView: View {
    @StateObject private var viewModel = CurrencyViewModel()
    @State private var amount: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SelectedCurrencyCard(selectedCurrency: viewModel.selectedCurrency,
                                     amount: $amount)
                
                List {
                    ForEach(viewModel.currencies) { currency in
                        CurrencyCard(
                            currency: currency,
                            selectedCurrency: viewModel.selectedCurrency,
                            currencyValue: viewModel.getCurrencyValue(for: currency),
                            onTap: {
                                viewModel.selectCurrency(currency)
                            } )
                    }
                }
                .listStyle(.plain)
                .padding(0)
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    HStack {
                        Text("Currency Converter")
                            .foregroundStyle(.white)
                            .font(.title2)
                        Spacer()
                    }
                }
            }
            .toolbarBackground(.teal, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .onChange(of: amount) { _, newValue in
            viewModel.updateRates(for: newValue)
        }
    }
}

struct CurrencyListView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyListView()
    }
}
