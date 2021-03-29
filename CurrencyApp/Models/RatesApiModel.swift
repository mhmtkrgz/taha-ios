//
//  RatesApiModel.swift
//  CurrencyApp
//
//  Created by Taha on 24.03.2021.
//

import Foundation

class RatesApiModel: Codable {
    let base: String
    let rates: [String: Double]
    let date: String

    init(base: String, rates: [String: Double], date: String) {
        self.base = base
        self.rates = rates
        self.date = date
    }
}

struct Currency {
    let name: String
    let rate: Double
    let abbreviation: String
}
