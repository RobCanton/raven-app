//
//  BidAskView.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-04.
//

import Foundation
import UIKit

class BidAskView:UIView {
    private var stackView:UIStackView!
    private var barView:UIView!
    private var bidBarView:UIView!
    private var askBarView:UIView!
    private var bidSizeLabel:UILabel!
    private var askSizeLabel:UILabel!
    private var bidPriceLabel:UILabel!
    private var askPriceLabel:UILabel!
    private var bidBoxView:UIView!
    private var askBoxView:UIView!
    
    var bidBarWidthAnchor:NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        stackView = UIStackView()
        stackView.axis = .vertical
        addSubview(stackView)
        stackView.constraintToSuperview()
        
        
        barView = UIView()
        //barView.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        barView.constraintHeight(to: 2)
        stackView.addArrangedSubview(barView)
        
        bidBarView = UIView()
        bidBarView.backgroundColor = UIColor.label//systemRed
        barView.addSubview(bidBarView)
        bidBarView.constraintToSuperview(0, 0, 0, nil, ignoreSafeArea: false)
        
        bidBarWidthAnchor = bidBarView.widthAnchor.constraint(equalToConstant: 0)
        bidBarWidthAnchor.isActive = true
        
        askBarView = UIView()
        askBarView.backgroundColor = UIColor.secondaryLabel
        barView.addSubview(askBarView)
        askBarView.constraintToSuperview(0, nil, 0, 0, ignoreSafeArea: false)
        
        askBarView.leadingAnchor.constraint(equalTo: bidBarView.trailingAnchor, constant:  4).isActive = true
       
        let bottomRow = UIView()
        bottomRow.constraintHeight(to: 24)
        stackView.addArrangedSubview(bottomRow)
        //bottomRow.backgroundColor = UIColor.yellow
        
        bidBoxView = UIView()
        //bidBoxView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        bottomRow.addSubview(bidBoxView)
        bidBoxView.constraintToSuperview(0, 0, 0, nil, ignoreSafeArea: false)
        //bidBoxView.backgroundColor = UIColor.red
        askBoxView = UIView()
        //askBoxView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        bottomRow.addSubview(askBoxView)
        askBoxView.constraintToSuperview(0, nil, 0, 0, ignoreSafeArea: false)
        
        askBoxView.leadingAnchor.constraint(equalTo: bidBoxView.trailingAnchor, constant: 5).isActive = true
        //askBoxView.backgroundColor = UIColor.green
        askBoxView.widthAnchor.constraint(equalTo: bidBoxView.widthAnchor).isActive = true
        
        let divider = UILabel()
        //divider.backgroundColor = UIColor.white
        //divider.constraintWidth(to: 0.5)
        divider.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        divider.text = "/"
        bottomRow.addSubview(divider)
        divider.constraintToSuperview(4, nil, 4, nil, ignoreSafeArea: false)
        divider.constraintToCenter(axis: [.x])
        
        
        
        bidSizeLabel = UILabel()
        bidSizeLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        bidBoxView.addSubview(bidSizeLabel)
        bidSizeLabel.constraintToSuperview(0, 0, 0, nil, ignoreSafeArea: false)
        
        bidPriceLabel = UILabel()
        bidPriceLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        bidPriceLabel.textColor = UIColor.label
        bidBoxView.addSubview(bidPriceLabel)
        bidPriceLabel.constraintToSuperview(0, nil, 0, 6, ignoreSafeArea: false)
        
        askSizeLabel = UILabel()
        askSizeLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        askBoxView.addSubview(askSizeLabel)
        askSizeLabel.constraintToSuperview(0, nil, 0, 0, ignoreSafeArea: false)
        
        askPriceLabel = UILabel()
        askPriceLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        askPriceLabel.textColor = UIColor.label
        askBoxView.addSubview(askPriceLabel)
        askPriceLabel.constraintToSuperview(0, 6, 0, nil, ignoreSafeArea: false)
        
        
    }
    
    func displayQuote(_ quote:Stock.Quote?=nil) {
        if let quote = quote {
            barView.alpha = 1.0
            bidSizeLabel.text = "\(quote.bidsize)"
            bidPriceLabel.text = "\(quote.bidprice)"
            
            askSizeLabel.text = "\(quote.asksize)"
            askPriceLabel.text = "\(quote.askprice)"
            
            let ratio = CGFloat(quote.bidsize) / (CGFloat(quote.bidsize) + CGFloat(quote.asksize))
            
            bidBarWidthAnchor.constant = ratio * self.frame.width
            layoutIfNeeded()
        } else {
             reset()
        }
        
    }
    
    func reset() {
        barView.alpha = 0.25
        bidSizeLabel.text = nil
        bidPriceLabel.text = nil
        askSizeLabel.text = nil
        askPriceLabel.text = nil
        
    }
}
