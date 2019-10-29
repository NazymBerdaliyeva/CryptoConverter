//
//  QuotesTableViewController.swift
//  CryptoConverter
//
//  Created by mac on 10/6/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import JGProgressHUD

class QuotesTableViewController: UITableViewController {

    @IBAction func refreshBarButton(_ sender: UIBarButtonItem) {
        self.hud.dismiss(animated: true)
        quoteProvider.loadQuoteData {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    let hud = JGProgressHUD(style: .dark)
    var quoteProvider = QuoteProvider()
    var oldQuotes: [Quote] = []
    var newQuotes: [Quote] = []
    var timer: Timer?
    var timerStatus = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getQuotes), name: Notification.Name("quotesTransfer"), object: nil)
    }
    
    
    @objc func getQuotes(notif: Notification) {
        if let quotes = notif.object as? [Quote] {
            newQuotes = quotes
            self.hud.dismiss(animated: true)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newQuotes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let quote = newQuotes[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath) as? QuoteCell {
            cell.quoteLabel.text = quote.name
            cell.symbolLabel.text = quote.symbol
            cell.iconImageView.image = UIImage(named: String("quote\(indexPath.row)"))
            cell.priceLabel.text = "\(quote.priceUsd)$"
            
            let priceChanges = getUpdatePrice(change: Double(quote.percentChange1h)!)
            cell.changeLabel.text = "\(priceChanges.0)%"
            cell.changeLabel.textColor = priceChanges.1
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "quotesListToDetail" {
            if let cell = sender as? QuoteCell {
                if let indexPath = tableView.indexPath(for: cell) {
                    let quote = newQuotes[indexPath.row]
                    
                    let detailVC = segue.destination as? QuoteDetailViewController
                    detailVC?.quote = quote
                    print(quote)
                }
                
            }
        }
    }
    
    func getUpdatePrice(change: Double) -> (String , UIColor){
        if change > 0 {
            return ("↑ \(change)", .green)
        } else {
            return ("↓ \(change)", .red)
        }
    }
}
