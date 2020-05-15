//
//  Stock.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-02.
//

import Foundation
import UIKit

protocol StockDelegate:class {
    func stockDidUpdate()
}

class Stock:Codable {
    let symbol:String
    let details:Details
    private(set) var trades:[Trade] // 
    var lastQuote:Quote?
    let previousClose:Close?
    let order:Int
    
    func addTrade(_ trade:Trade) {
        self.trades.append(trade)
        if trades.count >= 2000 {
            trades.remove(at: 0)
        }
        
    }
    
    var change:Double? {
        if let price = trades.last?.price,
            let previousClose = previousClose?.close {
            return price - previousClose
        }
        return nil
    }
    
    var changePercent:Double? {
        if let change = change,
            let previousClose = previousClose?.close {
            let changePercent = abs(change / previousClose) * 100
            
            return changePercent
        }
        return nil
    }
    
    var changeStr:String? {
        guard let change = change else { return nil }
        let formatted = NumberFormatter.localizedString(from: NSNumber(value: change),
                                                        number: NumberFormatter.Style.decimal)
        if change > 0 {
            return "+\(formatted)"
        }
        
        return formatted
    }
    
    var changePercentStr:String? {
        guard let changePercent = changePercent else { return nil }
        return "\(String(format: "%.2f", locale: Locale.current, changePercent))%"
    }
    
    var changeCompositeStr:String {
        guard let change = changeStr, let changePercent = changePercentStr else { return "" }
        
        return "\(change) (\(changePercent))"
    }
    
    var changeColor:UIColor {
        guard let change = change else { return UIColor.label }
        if change > 0 {
            return UIColor(hex: "33E190")
        } else if change < 0 {
            return UIColor(hex: "FF3860")
        } else {
            return UIColor.label
        }
    }
}

extension Stock {
    struct Details:Codable {
        let ceo:String?
        let country:String?
        let description:String?
        let employees:Int?
        let exchange:String?
        let exchangeSymbol:String?
        //let industry:String?
        //let marketcap:Int?
        let shares:Double?
        let name:String?
        //let type:String
        //let updated:String?
        //let url:String?
    }
    
    struct Trade:Codable, Comparable, Equatable {
        let price:Double
        let exchange:Int
        let size:Int
        let timestamp:TimeInterval
        
        static func < (lhs: Trade, rhs: Trade) -> Bool {
            return lhs.timestamp < rhs.timestamp
        }
    }
    
    struct Quote:Codable {
        let askexchange:Int
        let askprice:Double
        let asksize:Int
        let bidexchange:Int
        let bidprice:Double
        let bidsize:Int
        let timestamp:TimeInterval
    }
    
    struct Close:Codable {
        let open:Double?
        let close:Double?
        let high:Double?
        let low:Double?
    }
}


struct TickerSearchResponse:Codable {
    let tickers:[Ticker]
}

struct Ticker:Codable {
    let symbol:String
    let securityName:String
    let exchange:String
}

struct CryptoTicker:Codable {
    let ticker: String
    let currency: String
    let attrs:Attributes
    
    struct Attributes:Codable {
        let baseName: String
        let base: String
    }
}


