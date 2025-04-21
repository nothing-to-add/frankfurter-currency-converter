//
//  File name: NetworkManager.swift
//  Project name: frankfurter-currency-converter
//  Workspace name: frankfurter-currency-converter
//
//  Created by: nothing-to-add on 21/04/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import Foundation

final class NetworkManager {
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func fetchData<T: Decodable>(from urlString: String, as type: T.Type) async throws -> T {
        let result = try await self.httpClient.get(from: urlString)
        switch result {
        case .success(let (data, _)):
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                return decodedData
            } catch {
                throw NetworkError.decodingError
            }
        case .failure(let error):
            throw error
        }
    }
}
