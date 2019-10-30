//
//  RealmHelper.swift
//  CryptoConverter
//
//  Created by mac on 10/30/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import RealmSwift

class RealmHelper {
    func fetchQuotesFromStorage() -> [Quote]? {
        do {
            let realm = try Realm()
            return realm
                .objects(QuoteCached.self)
                .map { Quote(fromCached: $0)} as [Quote]
        } catch let error as NSError {
            print("Error reading from storage: \(error.localizedDescription)")
        }
        return nil
    }
    
    func writeQuotesToStorage(quotes: [Quote]) {
        quotes.map{QuoteCached(quote: $0)}
            .forEach { (quote) in
                do {
                    let realm = try Realm()
                    try realm.write ({
                        realm.add(quote, update: .modified)
                    })
                } catch let error as NSError {
                    print("Error writing quotes to storage: \(error.localizedDescription)")
                }
        }
    }
}



