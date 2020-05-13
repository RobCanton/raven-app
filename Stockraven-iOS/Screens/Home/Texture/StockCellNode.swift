//
//  StockCellNode.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-07.
//

import Foundation
import AsyncDisplayKit


class StockCellNode:ASCellNode {
    var stock:Stock
    var symbolTextNode = ASTextNode()
    var nameTextNode = ASTextNode()
    var priceTextNode = ASTextNode()
    var changeTextNode = ASTextNode()
    var bidAskNode:BidAskNode!
    
    init(stock:Stock) {
        self.stock = stock
        self.bidAskNode = BidAskNode(quote: stock.lastQuote)
        super.init()
        
        self.automaticallyManagesSubnodes = true
        
        symbolTextNode.attributedText = NSAttributedString(string: stock.symbol, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.label,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .semibold)
        ])
        
        nameTextNode.attributedText = NSAttributedString(string: stock.details.name ?? "", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular)
        ])
        
        updateTrade(self.stock)
        updateQuote(self.stock)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let nameColumn = ASStackLayoutSpec.vertical()
        nameColumn.children = [symbolTextNode, nameTextNode]
        nameColumn.spacing = 2
        
        let priceColumn = ASStackLayoutSpec.vertical()
        priceColumn.children = [priceTextNode, changeTextNode]
        priceColumn.horizontalAlignment = .right
        priceColumn.spacing = 2
        
        let mainRow = ASStackLayoutSpec.horizontal()
        mainRow.children = [nameColumn, priceColumn]
        mainRow.justifyContent = .spaceBetween
        
        let contentColumn = ASStackLayoutSpec.vertical()
        contentColumn.children = [mainRow, bidAskNode]
        contentColumn.spacing = 8
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16), child: contentColumn)
    }
    
    func updateTrade(_ stock:Stock) {
        self.stock = stock
        
        let priceStr = String(format: "%.2f",
                              locale: Locale.current,
                              stock.trades.last?.price ?? -1)
        priceTextNode.attributedText = NSAttributedString(string: priceStr, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.label,
            NSAttributedString.Key.font: UIFont.monospacedSystemFont(ofSize: 20, weight: .bold)//systemFont(ofSize: 20, weight: .bold)
        ])
               
        changeTextNode.attributedText = NSAttributedString(string: stock.changeCompositeStr, attributes: [
            NSAttributedString.Key.foregroundColor: stock.changeColor,
            NSAttributedString.Key.font: UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)//systemFont(ofSize: 14, weight: .regular)
        ])
    }
    
    func updateQuote(_ stock:Stock) {
        self.stock = stock
        self.bidAskNode.displayQuote(stock.lastQuote)
    }
}
