//
//  StockTitleHeaderCell.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-13.
//

import Foundation
import UIKit

class StockTitleHeaderCell:UITableViewCell {
    
    var titleLabel:UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        titleLabel = UILabel()
        contentView.addSubview(titleLabel)
        titleLabel.constraintToSuperview(16, 16, 8, 16, ignoreSafeArea: false)
        titleLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        titleLabel.textColor = UIColor.secondaryLabel
    }
    
}
