//
//  File name: CurrencyDescription.swift
//  Project name: frankfurter-currency-converter
//  Workspace name: frankfurter-currency-converter
//
//  Created by: nothing-to-add on 19/04/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import Foundation

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
