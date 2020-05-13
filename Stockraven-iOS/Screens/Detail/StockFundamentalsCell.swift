//
//  StockFundamentalsCell.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-12.
//

import Foundation
import UIKit

class StockFundamentalsCell:UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        contentView.backgroundColor = UIColor.red
        constraintHeight(to: 128)
    }
    
}
