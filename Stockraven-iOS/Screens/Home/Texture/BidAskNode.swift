//
//  BidAskNode.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-07.
//

import Foundation
import AsyncDisplayKit

class BidAskNode:ASDisplayNode {
    var barNode:BarNode
    
    let bidSizeTextNode = ASTextNode()
    let bidPriceTextNode = ASTextNode()
    let askSizeTextNode = ASTextNode()
    let askPriceTextNode = ASTextNode()
    
    let dividerTextNode = ASTextNode()
    
    
    init(quote:Stock.Quote?=nil) {
        var ratio:CGFloat = 0
        if let quote = quote {
            ratio = CGFloat(quote.bidsize) / (CGFloat(quote.bidsize) + CGFloat(quote.asksize))
        }
        barNode = BarNode(ratio: ratio)
        super.init()
        self.automaticallyManagesSubnodes = true
        
        dividerTextNode.attributedText = NSAttributedString(string: "/", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.label,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular)
        ])
        
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        barNode.style.height = ASDimension(unit: .points, value: 4)
        
        
        let bidRow = ASStackLayoutSpec.horizontal()
        bidRow.children = [bidSizeTextNode, bidPriceTextNode]
        bidRow.justifyContent = .spaceBetween
        bidRow.style.width = ASDimension(unit: .points, value: (constrainedSize.max.width/2) - 2)
        
        let askRow = ASStackLayoutSpec.horizontal()
        askRow.children = [askPriceTextNode, askSizeTextNode]
        askRow.justifyContent = .spaceBetween
        askRow.style.width = ASDimension(unit: .points, value: (constrainedSize.max.width/2) - 2)
        
        let numbersRow = ASStackLayoutSpec.horizontal()
        numbersRow.children = [bidRow, askRow]
        numbersRow.justifyContent = .spaceBetween
        numbersRow.spacing = 4
        
        let mainColumn = ASStackLayoutSpec.vertical()
        mainColumn.spacing = 4
        mainColumn.children = [barNode, numbersRow]
        
        return mainColumn
        
    }
    
    func displayQuote(_ quote:Stock.Quote?=nil) {
        if let quote = quote {
            
            bidSizeTextNode.attributedText = NSAttributedString(string: "\(quote.bidsize)", attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.label,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular)
            ])
            
            askSizeTextNode.attributedText = NSAttributedString(string: "\(quote.asksize)", attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.label,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular)
            ])
            
            bidPriceTextNode.attributedText = NSAttributedString(string: "\(quote.bidprice)", attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.label,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular)
            ])
            
            askPriceTextNode.attributedText = NSAttributedString(string: "\(quote.askprice)", attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular)
            ])
            
            let ratio = CGFloat(quote.bidsize) / (CGFloat(quote.bidsize) + CGFloat(quote.asksize))
            DispatchQueue.main.async {
                self.barNode.displayRatio(ratio)
            }
        } else {
            bidSizeTextNode.attributedText = nil
            askSizeTextNode.attributedText = nil
            bidPriceTextNode.attributedText = nil
            askPriceTextNode.attributedText = nil
        }
        
    }
}

class BarNode:ASDisplayNode {
    var ratio:CGFloat
    
    var bidBarView:UIView!
    var askBarView:UIView!
    
    var barWidthAnchor:NSLayoutConstraint!
    
    
    init(ratio:CGFloat) {
        self.ratio = ratio
        super.init()
    }
    
    override func didLoad() {
        super.didLoad()
        bidBarView = UIView()
        askBarView = UIView()
        
        bidBarView.backgroundColor = UIColor.label
        askBarView.backgroundColor = UIColor.secondaryLabel
        
        view.addSubview(bidBarView)
        view.addSubview(askBarView)
        
        bidBarView.constraintToSuperview(0, 0, 0, nil, ignoreSafeArea: true)
        askBarView.constraintToSuperview(0, nil, 0, 0, ignoreSafeArea: true)
        askBarView.leadingAnchor.constraint(equalTo: bidBarView.trailingAnchor, constant: 4).isActive = true
        
        let maxWidth = self.constrainedSizeForCalculatedLayout.max.width
        barWidthAnchor = bidBarView.widthAnchor.constraint(equalToConstant: maxWidth * ratio - 2)
        barWidthAnchor.isActive = true
        
        
    }
    
    func displayRatio(_ ratio:CGFloat) {
        self.ratio = ratio
        guard self.isNodeLoaded else { return }
        let maxWidth = self.constrainedSizeForCalculatedLayout.max.width
        barWidthAnchor.constant = maxWidth * ratio - 2
        view.layoutIfNeeded()
        
    }
    
    
}
