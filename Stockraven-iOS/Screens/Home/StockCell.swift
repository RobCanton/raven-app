//
//  StockCell3.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-12.
//

import Foundation
import UIKit

class StockCell:UITableViewCell {
    
    weak var stock:Stock?
    
    var titleRow:UIView!
    var symbolLabel:UILabel!
    var nameLabel:UILabel!
    var priceLabel:UILabel!
    var changeLabel:UILabel!
    var liveChartView:LiveChartMiniView!
    var chartView:ChartView!
    var bidAskView:BidAskView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        titleRow = UIView()
        contentView.addSubview(titleRow)
        titleRow.constraintToSuperview(16, 16, nil, 16, ignoreSafeArea: true)
        
        symbolLabel = UILabel()
        symbolLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleRow.addSubview(symbolLabel)
        symbolLabel.constraintToSuperview(0, 0, nil, nil, ignoreSafeArea: true)
        
        nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        nameLabel.textColor = .secondaryLabel
        titleRow.addSubview(nameLabel)
        nameLabel.constraintToSuperview(nil, 0, nil, nil, ignoreSafeArea: true)
        nameLabel.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor, constant: 3).isActive = true
        
        priceLabel = UILabel()
        priceLabel.font = UIFont.monospacedSystemFont(ofSize: 20, weight: .bold)
        priceLabel.textAlignment = .right
        titleRow.addSubview(priceLabel)
        priceLabel.constraintToSuperview(nil, nil, nil, 0, ignoreSafeArea: false)
        priceLabel.lastBaselineAnchor.constraint(equalTo: symbolLabel.lastBaselineAnchor).isActive = true
        
        changeLabel = UILabel()
        changeLabel.font = UIFont.monospacedSystemFont(ofSize: 13, weight: .regular)
        changeLabel.textAlignment = .right
        titleRow.addSubview(changeLabel)
        changeLabel.constraintToSuperview(nil, nil, 0, 0, ignoreSafeArea: false)
        changeLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 3).isActive = true
        
        nameLabel.lastBaselineAnchor.constraint(equalTo: changeLabel.lastBaselineAnchor).isActive = true
        
        let chartContainer = UIView()
        titleRow.addSubview(chartContainer)
        chartContainer.constraintToCenter(axis: [.x])
        chartContainer.constraintToSuperview(8, nil, 8, nil, ignoreSafeArea: true)
        chartContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2).isActive = true
        
        liveChartView = LiveChartMiniView()
        chartContainer.addSubview(liveChartView)
        liveChartView.constraintToSuperview()
        
        chartView = ChartView()
        chartContainer.addSubview(chartView)
        chartView.constraintToSuperview()
        chartView.isHidden = true
        
        symbolLabel.trailingAnchor.constraint(equalTo: chartContainer.leadingAnchor, constant: -8).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: chartContainer.leadingAnchor, constant: -8).isActive = true
        
        priceLabel.leadingAnchor.constraint(equalTo: chartContainer.trailingAnchor, constant: 8).isActive = true
        changeLabel.leadingAnchor.constraint(equalTo: chartContainer.trailingAnchor, constant: 8).isActive = true
        
        
        bidAskView = BidAskView(.compact)
        contentView.addSubview(bidAskView)
        bidAskView.constraintToSuperview(nil, 16, 16, 16, ignoreSafeArea: true)
        bidAskView.topAnchor.constraint(equalTo: titleRow.bottomAnchor, constant: 12).isActive = true
        
    }
    
    func configure(stock:Stock) {
        self.stock = stock
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.addObserver(self, selector: #selector(updateTradeDisplay), type: .stockTradeUpdated(stock.symbol))
        NotificationCenter.addObserver(self, selector: #selector(updateQuoteDisplay), type: .stockQuoteUpdated(stock.symbol))
        updateDisplay()
    }
    
    @objc private func updateDisplay() {
        guard let stock = self.stock else { return }
        symbolLabel.text = stock.symbol
        nameLabel.text = stock.details.name
        updateTradeDisplay()
        bidAskView.displayQuote(stock.lastQuote)
    }
    
    @objc private func updateTradeDisplay() {
        guard let stock = self.stock else { return }
        priceLabel?.text = String(format: "%.2f", locale: Locale.current, stock.trades.last?.price ?? 0)
        changeLabel?.text = stock.changeCompositeStr
        changeLabel?.textColor = stock.changeColor
        
        if StockManager.shared.marketStatus == .closed,
            let intraday = stock.intraday {
            chartView.isHidden = false
            liveChartView.isHidden = true
            chartView.displayTicks(intraday)
        } else {
            chartView.isHidden = true
            liveChartView.isHidden = false
            liveChartView.displayTrades(stock.trades, positive: (stock.change ?? 0) >= 0)
        }
    }
    
    @objc private func updateQuoteDisplay() {
        guard let stock = self.stock else { return }
        bidAskView.displayQuote(stock.lastQuote)
    }
    
}

extension StockCell: StockDelegate {
    func stockDidUpdate() {
        updateDisplay()
    }
}
