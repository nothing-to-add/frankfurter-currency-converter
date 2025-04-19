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
                selectedCurrencyCard()
                
                List {
                    ForEach(viewModel.currencies) { currency in
                        listCardForCurrency(currency)
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
            viewModel.updateRates(for: Double(newValue))
        }
    }
    
    @ViewBuilder
    private func listCardForCurrency(_ currency: Currency) -> some View {
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
                Text(viewModel.getCurrencyValue(for: currency))
                    .font(.headline)
                    .transition(.opacity)
                    .animation(.easeInOut, value: viewModel.getCurrencyValue(for: currency))
                Text(String(format: "1 \(viewModel.selectedCurrency?.code ?? "") = %.2f", currency.rate))
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
        .opacity(currency.code == viewModel.selectedCurrency?.code ?? "" ? 0 : 1)
        .animation(.easeInOut, value: viewModel.selectedCurrency?.code)
        .onTapGesture {
            viewModel.selectCurrency(currency)
        }
    }
    
    @ViewBuilder
    private func selectedCurrencyCard() -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(viewModel.selectedCurrency?.code ?? "Code")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .transition(.opacity)
                    .animation(.easeInOut, value: viewModel.selectedCurrency?.code)
                Text(CurrencyDescription().getDescription(for: viewModel.selectedCurrency ?? Currency(code: "None", rate: 0.0)))
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .transition(.opacity)
                    .animation(.easeInOut, value: viewModel.selectedCurrency?.code)
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

struct CurrencyListView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyListView()
    }
}
