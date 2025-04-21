//
//  File name: Response.swift
//  Project name: frankfurter-currency-converter
//  Workspace name: frankfurter-currency-converter
//
//  Created by: nothing-to-add on 19/04/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import Foundation

// Model of API Response
struct Response: Codable, Equatable {
    let amount: Double
    let base: String
    let date: String
    let rates: [String: Double]
}
