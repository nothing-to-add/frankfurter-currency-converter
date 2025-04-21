//
//  File name: HTTPClient.swift
//  Project name: frankfurter-currency-converter
//  Workspace name: frankfurter-currency-converter
//
//  Created by: nothing-to-add on 21/04/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import Foundation

protocol HTTPClient {
    
    func get(from urlString: String) async throws -> Swift.Result<(Data, HTTPURLResponse), Error>
}
