//
//  AlertsSummaryCell.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-13.
//

import Foundation
import UIKit
import MSPeekCollectionViewDelegateImplementation


protocol AlertsSummaryDelegate:class {
    func alertsSummaryAddAlert()
    func alertsSummary(didSelect alert:Alert)
}

class AlertSummaryCell:UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate{
    
    weak var delegate:AlertsSummaryDelegate?
    weak var stock:Stock?
    private var alerts = [Alert]()
    private var groupedAlerts = [[Alert]]()
    var titleLabel:UILabel!
    var collectionView:UICollectionView!
    var rightButton:UIButton!
    var newAlertButton:UIButton!
    
    var behavior: MSCollectionViewPeekingBehavior!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.selectionStyle = .none
        titleLabel = UILabel()
        contentView.addSubview(titleLabel)
        titleLabel.constraintToSuperview(16, 16, nil, 16, ignoreSafeArea: false)
        titleLabel.text = "Alerts"
        titleLabel.font = UIFont.systemFont(ofSize: 24.0, weight: .semibold)
        titleLabel.constraintHeight(to: 50)
        
        rightButton = UIButton(type: .system)
        contentView.addSubview(rightButton)
        rightButton.constraintToSuperview(nil, nil, nil, 16)
        rightButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        rightButton.tintColor = Theme.current.primary
        //let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
        //rightButton.setImage(UIImage(systemName: "plus", withConfiguration: boldConfig), for: .normal)
        rightButton.setTitle("See All", for: .normal)
        rightButton.setTitleColor(Theme.current.primary, for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        rightButton.addTarget(self, action: #selector(handleRightButton), for: .touchUpInside)
        //UIButton(type: .contactAdd)
        //rightButton.setImage(UIImage(systemName: "plus"), for: .normal)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
//        //layout.itemSize = CGSize(width: 100, height: 100)
//        layout.estimatedItemSize = CGSize(width: 128, height: 128)
//        layout.minimumLineSpacing = 12.0
//
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        contentView.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0).isActive = true
        collectionView.constraintToSuperview(nil, 0, nil, 0, ignoreSafeArea: false)
        collectionView.constraintHeight(to: 52 * 3)
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(AlertsStackCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.showsHorizontalScrollIndicator = false
        //collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        
        behavior = MSCollectionViewPeekingBehavior(cellSpacing: 8, cellPeekWidth: 8, maximumItemsToScroll: 5, numberOfItemsToShow: 1, scrollDirection: .horizontal)
        collectionView.configureForPeekingBehavior(behavior: behavior)
        collectionView.reloadData()
        
        newAlertButton = UIButton(type: .system)
        contentView.addSubview(newAlertButton)
        newAlertButton.constraintToSuperview(nil, 16, 16, nil, ignoreSafeArea: false)
        newAlertButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 6).isActive = true
        
        self.layoutIfNeeded()
        //let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
        //newAlertButton.setImage(UIImage(systemName: "plus", withConfiguration: boldConfig), for: .normal)
        newAlertButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        newAlertButton.setTitle("Add Alert", for: .normal)
        newAlertButton.setTitleColor(Theme.current.primary, for: .normal)
        //newAlertButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        //newAlertButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4)
        
        newAlertButton.sizeToFit()
        newAlertButton.addTarget(self, action: #selector(handleNewAlertButton), for: .touchUpInside)
        
    }
    
    func configure(_ stock:Stock) {
        self.stock = stock
        self.alerts = StockManager.shared.alerts(for: stock.symbol)
        self.groupedAlerts = alerts.chunked(by: 3)
        print("groupedAlerts: \(groupedAlerts)")
        if groupedAlerts.count > 1 {
            collectionView.constraintHeight(to: 52 * 3)
            rightButton.isHidden = false
        } else {
            rightButton.isHidden = true
            var height:CGFloat = 0
            if let first = groupedAlerts.first {
                height += 52 * CGFloat(first.count)
            }
            collectionView.constraintHeight(to: height)
        }
        self.collectionView.reloadData()
        newAlertButton.sizeToFit()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupedAlerts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AlertsStackCell
        cell.configure(groupedAlerts[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        behavior.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print(behavior.currentIndex)
    }
    
    @objc func handleRightButton() {
        
    }
    
    @objc func handleNewAlertButton() {
        self.delegate?.alertsSummaryAddAlert()
    }
}

extension AlertSummaryCell:AlertsStackDelegate {
    func alertsStack(didSelect alert: Alert) {
        self.delegate?.alertsSummary(didSelect: alert)
    }
}
extension Collection {

    func chunked(by distance: Int) -> [[Element]] {
        var result: [[Element]] = []
        var batch: [Element] = []

        for element in self {
            batch.append(element)

            if batch.count == distance {
                result.append(batch)
                batch = []
            }
        }

        if !batch.isEmpty {
            result.append(batch)
        }

        return result
    }

}
