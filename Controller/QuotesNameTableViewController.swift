//
//  QuotesNameTableViewController.swift
//  CryptoConverter
//
//  Created by mac on 10/17/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import JGProgressHUD

class QuotesNameTableViewController: UITableViewController {

    @IBAction func closeBarButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    var quoteProvider = QuoteProvider()
    var quotes: [Quote] = []
    let hud = JGProgressHUD(style: .light)
    let realmHelper = RealmHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getQuotes), name: Notification.Name("quotesTransfer"), object: nil)
        
        if let quotes = realmHelper.fetchQuotesFromStorage(), quotes.count != 0 {
            self.quotes = quotes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            self.hud.dismiss(animated: true)
        }  else {
            quoteProvider.loadQuoteData()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    @objc func getQuotes(notif: Notification) {
        if let quotes = notif.object as? [Quote] {
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteNameCell", for: indexPath) as? QuoteNameCell {
            
            cell.nameLabel.text = quote.name
            cell.symbolLabel.text = quote.symbol
            cell.quoteImageView.image = UIImage(named: String("quote\(indexPath.row)"))
            return cell
        } else {
            return UITableViewCell()
        }

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        
        if let selectedIndex = indexPath {
            let selectedQuote = quotes[(selectedIndex.row)]
            NotificationCenter.default.post(name: Notification.Name("selectedQuote"), object: selectedQuote, userInfo: nil)
      
        }
        dismiss(animated: true, completion: nil)
    }
}
