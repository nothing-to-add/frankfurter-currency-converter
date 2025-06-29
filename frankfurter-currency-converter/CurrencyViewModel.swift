//
//  File name: CurrencyViewModel.swift
//  Project name: frankfurter-currency-converter
//  Workspace name: frankfurter-currency-converter
//
//  Created by: nothing-to-add on 19/04/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import Foundation
import Combine

// ViewModel for Currency Converter
@Observable
class CurrencyViewModel: ObservableObject {
    
    var currencies: [Currency] = []
    var selectedCurrency : Currency? = nil
    
    private var amount: Double = 1.0
    private var currencyBase: CurrentValueSubject<String, Never>
    private var timer = Timer()
    private var cancellables = Set<AnyCancellable>()
    private let currencyFetcher: CurrencyFetcherProtocol
    
    init(currencyFetcher: CurrencyFetcherProtocol = CurrencyFetcher()) {
        self.currencyFetcher = currencyFetcher
        currencyBase = CurrentValueSubject<String, Never>("EUR")
        initLiseners()
    }
    
    func initLiseners() {
        Publishers.Merge(
            currencyBase.eraseToAnyPublisher(),
            Timer.publish(every: 3.0, on: .main, in: .common)
                .autoconnect()
                .map { _ in self.currencyBase.value }
        )
        .removeDuplicates()
        .sink { [weak self] currency in
            if let self {
                Task { @MainActor in
                    await self.fetchCurrencies(base: currency)
                }
            }
        }
        .store(in: &cancellables)
    }
    
    @MainActor
    private func fetchCurrencies(base: String) async {
        do {
            let response = try await currencyFetcher.fetchRates(for: base)
                self.selectedCurrency = Currency(code: response.base, rate: response.amount)
            self.currencies = response.rates.map { Currency(code: $0.key, rate: $0.value) }
                .sorted { $0.code < $1.code }
        } catch let error as NetworkError {
            print(String(describing: error.errorDescription))
        } catch {
            print("Error decoding response: \(error)")
        }
    }
    
    func updateRates(for amount: String) {
        guard selectedCurrency != nil else { return }
        if let newValue = Double(amount) {
            self.amount = newValue
        } else {
            self.amount = 1.0
        }
    }
    
    func selectCurrency(_ currency: Currency) {
        currencyBase.send(currency.code)
    }
    
    func getCurrencyValue(for currency: Currency) -> String {
        String(format: "%.2f", currency.rate * amount)
    }
}
