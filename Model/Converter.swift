//
//  Converter.swift
//  CryptoConverter
//
//  Created by mac on 10/3/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

class Converter{
    var baseQuote: Quote
    
    init(baseQuote: Quote) {
        self.baseQuote = baseQuote
    }
    
    func convert(_ quoteCount: Double, _ convertQuote: Quote)-> Double{
        let result = 0.0
        if let firstPrice = Double(baseQuote.priceUsd), let secondPrice = Double(convertQuote.priceUsd) {
            return (quoteCount * secondPrice)/firstPrice
        }
        return result
    }
}
