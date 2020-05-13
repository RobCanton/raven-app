//
//  StockManager.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-02.
//

import Foundation
import UIKit
import SocketIO

enum MarketStatus:String {
    case open = "open"
    case closed = "closed"
    case premarket = "pre-market"
    case afterhours = "after-hours"
    
    var displayString:String {
        switch self {
        case .open:
            return "Market Open"
        case .closed:
            return "Market Closed"
        case .premarket:
            return "Pre-market"
        case .afterhours:
            return "After Hours"
        }
    }
}

class StockManager {
    
    static let shared = StockManager()
    
    private(set) var stocks = [Stock]()
    private var stockIndex = [String:Int]()
    
    private(set) var marketStatus = MarketStatus.closed
    
    private var socket:SocketIOClient!
    
    private(set) var alerts = [Alert]()
    private(set) var alertIndexes = [String:[Int]]()
    
    func alerts(for symbol:String) -> [Alert] {
        var _alerts = [Alert]()
        if let indexes = alertIndexes[symbol] {
            for i in indexes {
                _alerts.append(alerts[i])
            }
        }
        _alerts.sort(by: { return $0.timestamp < $1.timestamp })
        return _alerts
    }
    
    private let manager = SocketManager(socketURL: URL(string: "http://raven.replicode.io")!,
                                        config: [.log(false), .compress])
    func connect() {
        socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            
            for stock in self.stocks {
                self.addSocketListener(for: stock.symbol)
            }
        }
        
        socket.on("market-status") { data, ack in
            if let statusStr = data.first as? String,
                let status = MarketStatus(rawValue: statusStr) {
                self.marketStatus = status
                NotificationCenter.post(.marketStatusUpdated)
            }
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("socket disconnected")
            self.socket.connect()
        }

        socket.connect()
    }
    
    private func addSocketListener(for symbol:String) {
        
        self.socket.emit("join", with: [symbol])
        
        self.socket.on("T.\(symbol)") { data, ack in
            if let dict = data.first as? [String:Any] {

                guard let index = self.stockIndex[symbol] else { return }
                guard let price = dict["p"] as? Double,
                    let exchange = dict["x"] as? Int,
                    let size = dict["s"] as? Int,
                    let timestamp = dict["t"] as? TimeInterval else { return }
                
                let trade = Stock.Trade(price: price,
                                              exchange: exchange,
                                              size: size,
                                              timestamp: timestamp)
                
                let stock = self.stocks[index]
                
                stock.addTrade(trade)
                self.stocks.remove(at: index)
                self.stocks.insert(stock, at: index)
                
                NotificationCenter.post(.stockTradeUpdated(stock.symbol))
            }
        }
        
        self.socket.on("Q.\(symbol)") { data, ack in
            if let dict = data.first as? [String:Any] {
                
                guard let index = self.stockIndex[symbol] else { return }
                guard let askexchange = dict["ax"] as? Int,
                    let askprice = dict["ap"] as? Double,
                    let asksize = dict["as"] as? Int,
                    let bidexchange = dict["bx"] as? Int,
                    let bidprice = dict["bp"] as? Double,
                    let bidsize = dict["bs"] as? Int,
                    let timestamp = dict["t"] as? TimeInterval else { return }
                
                let quote = Stock.Quote(askexchange: askexchange,
                                              askprice: askprice,
                                              asksize: asksize,
                                              bidexchange: bidexchange,
                                              bidprice: bidprice,
                                              bidsize: bidsize,
                                              timestamp: timestamp)
                
                let stock = self.stocks[index]
                
                stock.lastQuote = quote
                self.stocks.remove(at: index)
                self.stocks.insert(stock, at: index)
                
                NotificationCenter.post(.stockQuoteUpdated(stock.symbol))
                
            }
        }
    }
    
    private func removeSocketListener(for symbol:String) {
        self.socket.off("T.\(symbol)")
        self.socket.off("Q.\(symbol)")
        self.socket.emit("leave", with: [symbol])
    }
    
    private init() {
        
    }
    
    func observe() {
        RavenAPI.getWatchlist { _stocks, _alerts in
            self.stocks = _stocks
            self.stockIndex = [:]
            for i in 0..<self.stocks.count {
                let stock = self.stocks[i]
                self.stockIndex[stock.symbol] = i
            }
            
            self.alerts = _alerts
            for i in 0..<self.alerts.count {
                let alert = self.alerts[i]
                if self.alertIndexes[alert.symbol] == nil {
                    self.alertIndexes[alert.symbol] = [i]
                } else {
                    self.alertIndexes[alert.symbol]!.append(i)
                }
            }
            self.connect()
            NotificationCenter.post(.stocksUpdated)
        }
    }
    
    func subscribe(to symbol:String) {
        RavenAPI.subscribe(to: symbol) { stock in
            
            guard let stock = stock else { return }
            self.stocks.append(stock)
            self.stockIndex[stock.symbol] = self.stocks.count - 1
            self.addSocketListener(for: stock.symbol)
            NotificationCenter.post(.stocksUpdated)
        }
    }
    
    func unsubscribe(from symbol:String) {
        
        self.stocks.removeAll(where: { stock in
            return stock.symbol == symbol
        })
        
        self.stockIndex = [:]
        for i in 0..<self.stocks.count {
            let stock = self.stocks[i]
            self.stockIndex[stock.symbol] = i
        }
        
        RavenAPI.unsubscribe(from: symbol) {
            self.socket.off("T.\(symbol)")
            self.socket.off("Q.\(symbol)")
        }
    }
    
    func addAlert(_ alert:Alert) {
        let index = alerts.count
        self.alerts.append(alert)
        
        if self.alertIndexes[alert.symbol] == nil {
            self.alertIndexes[alert.symbol] = [index]
        } else {
            self.alertIndexes[alert.symbol]!.append(index)
        }
        
        NotificationCenter.post(.alertsUpdated)
    }
    
    func updateAlert(_ alert:Alert) {
        guard let index = alerts.firstIndex(where: { $0.id == alert.id }) else { return }
        alerts[index] = alert
        
        NotificationCenter.post(.alertsUpdated)
    }
    
    func deleteAlert(withID id:String, completion: @escaping ()->()) {
        RavenAPI.deleteAlert(id) {
            completion()
        }
    }
    
    func moveStock(at sourceIndex: Int, to destinationIndex: Int) {
        let moveItem = self.stocks.remove(at: sourceIndex)
        self.stocks.insert(moveItem, at: destinationIndex)
        self.stockIndex = [:]
        for i in 0..<self.stocks.count {
            let stock = self.stocks[i]
            self.stockIndex[stock.symbol] = i
        }
        
        RavenAPI.patchWatchlist(self.stocks)
        
    }
    
}

