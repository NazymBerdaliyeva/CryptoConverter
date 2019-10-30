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
        quoteProvider.loadQuoteData()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
    }
    let hud = JGProgressHUD(style: .dark)
    var quoteProvider = QuoteProvider()
    var quotes: [Quote] = []
    let realmHelper = RealmHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(getQuotes), name: Notification.Name("quotesTransfer"), object: nil)
        
        let isFirstStart = !UserDefaults.standard.bool(forKey: "alreadyStartedBefore")
        if isFirstStart {
            self.tableView.isHidden = true
            let alert = UIAlertController(title: "Hello", message: "Welcome to Crypto Converter :)", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Get started", style: UIAlertAction.Style.default, handler: { _ in
                UserDefaults.standard.set(true, forKey: "alreadyStartedBefore")
                
                self.tableView.isHidden = false
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        
        if let quotes = realmHelper.fetchQuotesFromStorage(), quotes.count != 0 {
            self.quotes = quotes
            print("quotes here : \(quotes.count)")
            self.hud.dismiss(animated: true)
        } else {
            quoteProvider.loadQuoteData()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
        }
    }
    
    
    @objc func getQuotes(notif: Notification) {
        if let quotes = notif.object as? [Quote] {
            realmHelper.writeQuotesToStorage(quotes: quotes)
            self.quotes = quotes
            self.hud.dismiss(animated: true)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let quote = quotes[indexPath.row]
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
                    let quote = quotes[indexPath.row]
                    
                    let detailVC = segue.destination as? QuoteDetailViewController
                    detailVC?.quote = quote
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
