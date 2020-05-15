//
//  MultiChartView.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-14.
//

import Foundation
import UIKit


class MultiChartView:UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var stock:Stock?
    var liveChartView:LiveChartView!
    var chartView:ChartView!
    var collectionView:UICollectionView!
    
    let options = [
        "Live", "1D", "1W", "1M", "3M", "6M", "1Y", "2Y", "5Y", "ALL"
    ]
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        liveChartView = LiveChartView()
        self.addSubview(liveChartView)
        liveChartView.constraintToSuperview(0, 0, nil, 0, ignoreSafeArea: false)
        
        chartView = ChartView()
        self.addSubview(chartView)
        chartView.constraintToSuperview(0, 0, nil, 0, ignoreSafeArea: false)
        chartView.heightAnchor.constraint(equalTo: liveChartView.heightAnchor).isActive = true
        chartView.isHidden = true
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        //layout.itemSize = CGSize(width: 100, height: 100)
        layout.estimatedItemSize = CGSize(width: 52, height: 32)
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: liveChartView.bottomAnchor, constant: 12).isActive = true
        collectionView.constraintToSuperview(nil, 0, 0, 0, ignoreSafeArea: false)
        collectionView.constraintHeight(to: 32)
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(ChartOptionCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
    }
    
    func configure(_ stock:Stock) {
        self.stock = stock
        displayTrades(stock.trades, positive: (stock.change ?? 0) >= 0)
    }
    
    private func displayTrades(_ trades:[Stock.Trade], positive:Bool) {
        liveChartView.displayTrades(trades, positive: positive)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChartOptionCell
        cell.titleLabel.text = options[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let stock = self.stock else { return }
        if indexPath.row == 0 {
            print("Get aggregate!")
            liveChartView.isHidden = false
            chartView.isHidden = true
        } else {
            liveChartView.isHidden = true
            chartView.isHidden = false
            RavenAPI.getAggregate(for: stock.symbol, multiplier: 10, timespan: .minute, from: Date(), to: Date()) { ticks in
                print("done!")
                self.chartView.displayTicks(ticks)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 32)
    }
    
}

class ChartOptionCell:UICollectionViewCell {
    var titleLabel:UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        titleLabel.textColor = UIColor.secondaryLabel
        contentView.addSubview(titleLabel)
        titleLabel.constraintToCenter(axis: [.y,.x])
        titleLabel.textAlignment = .center
        self.layer.cornerRadius = 8
        self.layer.cornerCurve = .continuous
        self.clipsToBounds = true
    }
    
    
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                titleLabel.textColor = .label
                titleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
                self.backgroundColor = UIColor.label.withAlphaComponent(0.2)
                
            } else {
                titleLabel.textColor = .secondaryLabel
                titleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
                self.backgroundColor = UIColor.clear
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                titleLabel.textColor = .label
                self.backgroundColor = UIColor.label.withAlphaComponent(0.1)
            } else {
                titleLabel.textColor = .secondaryLabel
                self.backgroundColor = UIColor.clear
            }
        }
    }
}
