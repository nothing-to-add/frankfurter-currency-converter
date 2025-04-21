//
//  File name: HTTPClientManager.swift
//  Project name: frankfurter-currency-converter
//  Workspace name: frankfurter-currency-converter
//
//  Created by: nothing-to-add on 21/04/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import Foundation

struct HTTPClientManager {
    static let shared = HTTPClientManager()
    
    private init() {}
    
    func getHTTPClient() -> HTTPClient {
        RemoteHTTPClient()
        // add mock option
    }
}
