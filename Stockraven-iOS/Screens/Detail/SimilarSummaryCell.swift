//
//  SimilarSummaryCell.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-18.
//

import Foundation
import UIKit
import MSPeekCollectionViewDelegateImplementation
import Lottie

class SimilarSummaryCell:UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate{
    
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
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.showsHorizontalScrollIndicator = false
        //collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        
        behavior = MSCollectionViewPeekingBehavior(cellSpacing: 8, cellPeekWidth: 8, maximumItemsToScroll: 5, numberOfItemsToShow: 1, scrollDirection: .horizontal)
        collectionView.configureForPeekingBehavior(behavior: behavior)
        collectionView.reloadData()
        
        let a = Animation.named("pixel_square_3")
        
        let animationView = AnimationView(animation: a)
        contentView.addSubview(animationView)
        animationView.constraintToCenter(axis: [.x,.y])
        animationView.constraintWidth(to: 52)
        animationView.constraintHeight(to: 52)
        animationView.play()
        animationView.tintColor = UIColor.label
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.5
        animationView.alpha = 1.0
        
        /// A keypath that finds the color value for all `Fill 1` nodes.
        let fillKeypath = AnimationKeypath(keypath: "**.Fill 1.Color")
        /// A Color Value provider that returns a reddish color.
        let redValueProvider = ColorValueProvider(Color(r: 1, g: 1, b: 1, a: 1))
        /// Set the provider on the animationView.
        animationView.setValueProvider(redValueProvider, keypath: fillKeypath)
        
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.backgroundColor = UIColor.secondarySystemBackground//UIColor(white: 0.15, alpha: 1.0)
        cell.layer.cornerRadius = 12.0
        cell.layer.cornerCurve = .continuous
        cell.clipsToBounds = true
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        behavior.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print(behavior.currentIndex)
    }
    
}
