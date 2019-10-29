//
//  ViewController.swift
//  CryptoConverter
//
//  Created by mac on 10/3/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class ConverterViewController: UIViewController {
    
    @IBOutlet weak var firstQuoteButton: UIButton!
    @IBOutlet weak var secondQuoteButton: UIButton!

    @IBAction func firstButtonTapped(_ sender: UIButton) {
        tag = sender.tag
    }
    
    @IBAction func secondButtonTapped(_ sender: UIButton) {
        tag = sender.tag
    }
    
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    
    @IBAction func firstTextFieldChanged(_ sender: UITextField) {
        guard let quote1 = firstQuote else {return}
        newConverter = Converter(baseQuote: quote1)
         convertAndShowToSecondTF()
    }
    
    var tag = 1
    var quotes: [Quote] = []
    var firstQuote: Quote?
    var secondQuote: Quote?
    var newConverter: Converter?
    
    @objc func getSelectedQuote(notif: Notification) {
        if let data = notif.object as? Quote
        {
            var quoteNum = Int(data.rank) ?? 1
            quoteNum -= 1
            let icon = "quote\(quoteNum)"
            
            let index = quoteNum
            let coin = UIImage(named: icon)
            if tag == 1 {
                firstQuote = quotes[index]
                newConverter = Converter(baseQuote: quotes[index])
                firstQuoteButton.setBackgroundImage(coin, for: UIControl.State.normal)
                convertAndShowToSecondTF()
            } else {
                guard let firstQuote = firstQuote else {return}
                newConverter = Converter(baseQuote: firstQuote)
                secondQuote = quotes[index]
                secondQuoteButton.setBackgroundImage(coin, for: UIControl.State.normal)
                convertAndShowToSecondTF()
            }
        }
    }
    
    @objc func getQuotes(notif: Notification) {
        if let quotes = notif.object as? [Quote] {
            DispatchQueue.main.async {
                self.quotes = quotes
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(getQuotes), name: Notification.Name("quotesTransfer"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getSelectedQuote), name: Notification.Name("selectedQuote"), object: nil)
    }
    
    func convertAndShowToSecondTF() {
        if let converter = newConverter,let secondQuote = secondQuote{
            let firstQuoteNumber = firstTextField.text  ?? "0"
            self.secondTextField.text = String(format:"%.3f", converter.convert((firstQuoteNumber as NSString).doubleValue, secondQuote))
        }
    }
}

