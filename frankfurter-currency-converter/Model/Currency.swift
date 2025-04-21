//
//  File name: Currency.swift
//  Project name: frankfurter-currency-converter
//  Workspace name: frankfurter-currency-converter
//
//  Created by: nothing-to-add on 19/04/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import Foundation

// Model for Currency
struct Currency: Identifiable {
    let id = UUID()
    let code: String
    let rate: Double
}
