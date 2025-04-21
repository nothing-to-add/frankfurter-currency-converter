//
//  File name: CurrencyFetcher.swift
//  Project name: frankfurter-currency-converter
//  Workspace name: frankfurter-currency-converter
//
//  Created by: nothing-to-add on 21/04/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import Foundation

struct CurrencyFetcher {
    private let baseURL = "https://api.frankfurter.app/latest?base="
    
    func fetchRates(for currency: String) async throws -> Response {
        let networkManager = NetworkManager(httpClient: HTTPClientManager.shared.getHTTPClient())
        
        let data = try await networkManager.fetchData(from: baseURL + currency, as: Response.self)
        return data
    }
}
