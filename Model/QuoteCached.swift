//
//  QuoteCached.swift
//  CryptoConverter
//
//  Created by mac on 10/30/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import RealmSwift

class QuoteCached: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var symbol: String = ""
    @objc dynamic var rank: String = ""
    @objc dynamic var priceUsd: String = ""
    @objc dynamic var priceBtc: String = ""
    @objc dynamic var volumeUsd24h: String = ""
    @objc dynamic var marketCapUsd: String = ""
    @objc dynamic var availableSupply: String = ""
    @objc dynamic var totalSupply: String = ""
    @objc dynamic var percentChange1h: String = ""
    @objc dynamic var percentChange24h: String = ""
    @objc dynamic var percentChange7d: String = ""
    @objc dynamic var lastUpdated : String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init (quote: Quote){
        self.init()
        id = quote.id
        name = quote.name
        symbol = quote.symbol
        rank = quote.rank
        priceUsd = quote.priceUsd
        priceBtc = quote.priceBtc
        volumeUsd24h = quote.volumeUsd24h
        marketCapUsd = quote.marketCapUsd
        availableSupply = quote.availableSupply
        totalSupply = quote.totalSupply
        percentChange1h = quote.percentChange1h
        percentChange24h = quote.percentChange24h
        percentChange7d = quote.percentChange7d
        lastUpdated = quote.lastUpdated
    }
}
