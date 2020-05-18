//
//  CommentsSummaryCell.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-18.
//

import Foundation
import UIKit
import MSPeekCollectionViewDelegateImplementation

class CommentsSummaryCell:UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate{
    
    weak var delegate:NotesSummaryDelegate?
    
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
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        contentView.addSubview(collectionView)
      
        collectionView.constraintToSuperview(0, 0, 32, 0, ignoreSafeArea: false)
        collectionView.constraintHeight(to: 52 * 3)
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(CommentPreviewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.showsHorizontalScrollIndicator = false
        //collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        
        behavior = MSCollectionViewPeekingBehavior(cellSpacing: 8, cellPeekWidth: 8, maximumItemsToScroll: 5, numberOfItemsToShow: 1, scrollDirection: .horizontal)
        collectionView.configureForPeekingBehavior(behavior: behavior)
        collectionView.reloadData()
        
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CommentPreviewCell
        cell.titleLabel.text = "Time to be bullish?"
        cell.bodyLabel.text = "COVID deaths are down despite no vaccine in all countries, virus retreating, Europe reopening, TSA traffic numbers doubling since April, and more states reopening is reason for optimism in the travel sector."
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        behavior.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print(behavior.currentIndex)
    }
    
}


class CommentPreviewCell:UICollectionViewCell {
    var titleLabel:UILabel!
    var bodyLabel:UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        contentView.backgroundColor = UIColor.secondarySystemBackground
        layer.cornerRadius = 8.0
        layer.cornerCurve = .continuous
        clipsToBounds = true
        
        titleLabel = UILabel()
        contentView.addSubview(titleLabel)
        titleLabel.constraintToSuperview(16, 16, nil, 16, ignoreSafeArea: false)
        titleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        
        bodyLabel = UILabel()
        contentView.addSubview(bodyLabel)
        bodyLabel.constraintToSuperview(nil, 16, nil, 16, ignoreSafeArea: false)
        bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        bodyLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        bodyLabel.numberOfLines = 7
    }
}
