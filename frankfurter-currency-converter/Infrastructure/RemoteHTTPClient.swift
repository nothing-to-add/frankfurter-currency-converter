//
//  File name: RemoteHTTPClient.swift
//  Project name: frankfurter-currency-converter
//  Workspace name: frankfurter-currency-converter
//
//  Created by: nothing-to-add on 21/04/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import Foundation

final class RemoteHTTPClient: HTTPClient {
    func get(from urlString: String) async throws -> Swift.Result<(Data, HTTPURLResponse), Error> {
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noData
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError("Error with status code: \(httpResponse.statusCode)")
        }
        
        return .success((data, httpResponse))
    }
    
}
