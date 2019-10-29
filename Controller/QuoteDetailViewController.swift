//
//  QuoteDetailViewController.swift
//  CryptoConverter
//
//  Created by mac on 10/6/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class QuoteDetailViewController: UIViewController {

    
    @IBOutlet weak var priceUsdLabel: UILabel!
    @IBOutlet weak var priceBtcLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    @IBOutlet weak var marketCapLabel: UILabel!
    @IBOutlet weak var volume24hLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var availableSupplyLabel: UILabel!
    @IBOutlet weak var h24changeLabel: UILabel!
    
    var quote: Quote?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        unwrapOptionals()
    }
    
    func configureNavBar() {
        if self.navigationController == nil {
            return
        }
        let navView = UIView()
        
        let label = UILabel()
        guard let name = quote?.name else {
            return
        }
        guard let symbol = quote?.symbol else {
            return
        }
        
        label.text = "\(name))  \(symbol)"
        label.sizeToFit()
        label.center = navView.center
        label.textAlignment = NSTextAlignment.center
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        guard let quoteNumber = quote?.rank else {return}
        var number = Int(quoteNumber) ?? 1
        number -= 1
        let icon = "quote\(number)"
        imageView.image = UIImage(named: icon)
        
        let imageAspect = imageView.image!.size.width/imageView.image!.size.height
        imageView.frame = CGRect(x: label.frame.origin.x-label.frame.size.height*imageAspect, y: label.frame.origin.y, width: label.frame.size.height*imageAspect, height: label.frame.size.height)
        navView.addSubview(label)
        navView.addSubview(imageView)
        self.navigationItem.titleView = navView
        navView.sizeToFit()
    }
    
    func unwrapOptionals(){
        if let priceUsd = quote?.priceUsd, let priceBtc = quote?.priceBtc,
            let lastUpdated = quote?.lastUpdated, let marketCap = quote?.marketCapUsd,
            let vol24h = quote?.volumeUsd24h, let rank = quote?.rank,
            let h24change = quote?.percentChange24h,
            let availableSupply = quote?.availableSupply{
            priceUsdLabel.text = "\(priceUsd)$"
            priceBtcLabel.text = "\(priceBtc)$"
            let date = getDouble(lastUpdated)
            lastUpdatedLabel.text = date.getDateStringFromUTC()
            marketCapLabel.text = "\(marketCap)"
            volume24hLabel.text = "\(vol24h)"
            rankLabel.text = rank
            h24changeLabel.text = "\(h24change)%"
            availableSupplyLabel.text = "\(availableSupply)"
            print(lastUpdated)
        }
    }
    
    func getDouble(_ str:String) -> Double {
        if let number = Double(str) {
            return number
        } else {
            return 0.0
        }
    }
}
extension Double {
    func getDateStringFromUTC() -> String {
        let date = NSDate(timeIntervalSince1970 : self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeZone = .current
        
        return dateFormatter.string(from: date as Date)
    }
}
