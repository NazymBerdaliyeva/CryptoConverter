//
//  QuoteProvider.swift
//  CryptoConverter
//
//  Created by mac on 10/6/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

class QuoteProvider {
//    private var quotes: [Quote] = []
    var i = 1
    private var timer: Timer?
    
    init(){
//        self.loadQuoteData()
        timer = Timer.scheduledTimer(withTimeInterval: 5.0,repeats: true,
                                     block: {[weak self] timer in self?.loadQuoteData()})
    }
    
    func loadQuoteData() {
        guard let url = URL(string: "https://api.coinmarketcap.com/v1/ticker/") else {
            return
        }
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            if error != nil {
                print(error!)
            } else {
                guard let data = data else { return }
                do {
                    let quotes = try JSONDecoder().decode([Quote].self, from: data)
                    
                    DispatchQueue.main.async {
                         NotificationCenter.default.post(name: Notification.Name("quotesTransfer"), object: quotes, userInfo: nil)
                    }
                } catch let jsonErr {
                    print("Error serializing json:", jsonErr)
                }
            }
        }.resume()
    }
}
