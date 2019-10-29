//
//  Quote.swift
//  CryptoConverter
//
//  Created by mac on 10/3/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

public struct Quote: Codable {
    var id: String = ""
    var name: String = ""
    var symbol: String = ""
    var rank: String = ""
    var priceUsd: String = ""
    var priceBtc: String = ""
    var volumeUsd24h: String = ""
    var marketCapUsd: String = ""
    var availableSupply: String = ""
    var totalSupply: String = ""
    var percentChange1h: String = ""
    var percentChange24h: String = ""
    var percentChanage7d: String = ""
    var lastUpdated : String = ""
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case rank
        case priceUsd = "price_usd"
        case priceBtc = "price_btc"
        case volumeUsd24h = "24h_volume_usd"
        case marketCapUsd = "market_cap_usd"
        case availableSupply = "available_supply"
        case totalSupply = "total_supply"
        case percentChange1h = "percent_change_1h"
        case percentChange24h = "percent_change_24h"
        case percentChanage7d = "percent_change_7d"
        case lastUpdated = "last_updated"
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        symbol = try container.decode(String.self, forKey: .symbol)
        rank = try container.decode(String.self, forKey: .rank)
        priceUsd = try container.decode(String.self, forKey: .priceUsd)
        priceBtc = try container.decode(String.self, forKey: .priceBtc)
        volumeUsd24h = try container.decode(String.self, forKey: .volumeUsd24h)
        marketCapUsd = try container.decode(String.self, forKey: .marketCapUsd)
        availableSupply = try container.decode(String.self, forKey: .availableSupply)
        totalSupply = try container.decode(String.self, forKey: .totalSupply)
        percentChange1h = try container.decode(String.self, forKey: .percentChange1h)
        percentChange24h = try container.decode(String.self, forKey: .percentChange24h)
        percentChanage7d = try container.decode(String.self, forKey: .percentChanage7d)
        lastUpdated = try container.decode(String.self, forKey: .lastUpdated)
    }
}


