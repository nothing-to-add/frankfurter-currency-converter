//
//  File name: ContentView.swift
//  Project name: frankfurter-currency-converter
//  Workspace name: Untitled 1
//
//  Created by: nothing-to-add on 16/04/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import SwiftUI
import Combine

// Model for Currency
struct Currency: Identifiable {
    let id = UUID()
    let code: String
    let rate: Double
}

// Model of API Response
struct Response: Decodable {
    let amount: Double
    let base: String
    let date: String
    let rates: [String: Double]
}

// ViewModel for Currency Converter
class CurrencyViewModel: ObservableObject {
    @Published var currencies: [Currency] = []
    @Published var selectedCurrency: Currency? = nil
    private var amount: Double = 1.0
    private var currencyBase = "EUR"
    private var timer = Timer()
    
    private var cancellables = Set<AnyCancellable>()
    private let baseURL = "https://api.frankfurter.app/latest?base="
    
    init() {
        fetchCurrencies(base: currencyBase)
        startAutoRefresh()
    }
    
    func fetchCurrencies(base: String) {
        guard let url = URL(string: baseURL + currencyBase) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            guard let data = data else {
                print("No data received")
                return
            }
            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                DispatchQueue.main.async {
                    if self.selectedCurrency == nil {
                        self.selectedCurrency = Currency(code: response.base, rate: response.amount)
                    }
                    self.currencies = response.rates.map { Currency(code: $0.key, rate: $0.value) }
                        .sorted { $0.code < $1.code }
                }
            } catch {
                print("Error decoding response: \(error)")
            }
        }.resume()
    }
    
    func startAutoRefresh() {
        Timer.publish(every: 3.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                if let self, !currencies.isEmpty {
                    fetchCurrencies(base: currencyBase)
                }
            }
            .store(in: &cancellables)
    }
    
    func updateRates(for amount: Double?) {
        guard selectedCurrency != nil else { return }
        if let newValue = amount {
            self.amount = newValue
        } else {
            self.amount = 1.0
        }
        
    }
    
    func selectCurrency(_ currency: Currency) {
        selectedCurrency = nil
        currencyBase = currency.code
        fetchCurrencies(base: currency.code)
    }
    
    func getCurrencyValue(for currency: Currency) -> String {
        String(format: "%.2f", currency.rate * amount)
    }
}

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

struct CurrencyDescription {
    
    func getDescription(for currency: Currency) -> String {
        switch currency.code {
        case "AUD":
            return "Australian Dollar"
        case "BGN":
            return "Bulgarian Lev"
        case "BRL":
            return "Brazilian Real"
        case "CAD":
            return "Canadian Dollar"
        case "CHF":
            return "Swiss Franc"
        case "CNY":
            return "Chinese Yuan"
        case "CZK":
            return "Czech Koruna"
        case "DKK":
            return "Danish Krone"
        case "GBP":
            return "Pound Sterling"
        case "HKD":
            return "Hong Kong Dollar"
        case "HUF":
            return "Hungarian Forint"
        case "IDR":
            return "Indonesian Rupiah"
        case "ILS":
            return "Israeli Sheqel"
        case "INR":
            return "Indian Rupee"
        case "ISK":
            return "Icelandic Krona"
        case "JPY":
            return "Japanese Yen"
        case "KRW":
            return "South Korean Won"
        case "MXN":
            return "Mexican Peso"
        case "MYR":
            return "Malaysian Ringgit"
        case "NOK":
            return "Norwegian Krone"
        case "NZD":
            return "New Zealand Dollar"
        case "PHP":
            return "Philippine Peso"
        case "PLN":
            return "Polish Zloty"
        case "RON":
            return "Romanian Leu"
        case "SEK":
            return "Swedish Krona"
        case "SGD":
            return "Singapore Dollar"
        case "THB":
            return "Thai Baht"
        case "TRY":
            return "Turkish Lira"
        case "USD":
            return "US Dollar"
        case "ZAR":
            return "South African Rand"
        case "EUR":
            return "Euro"
        default:
            return "Unknown Currency"
        }
    }
}
