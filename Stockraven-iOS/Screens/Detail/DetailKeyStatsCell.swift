//
//  DetailKeyStatsCell.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-14.
//

import Foundation
import UIKit


class DetailKeyStatsCell:UITableViewCell {
    var stackView:UIStackView!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        contentView.addSubview(stackView)
        stackView.constraintToSuperview(12, 16, 12, 16, ignoreSafeArea: false)
        //stackView.constraintHeight(to: 44)
        
        addStat(title: "Open", value: "27.66")
        addStat(title: "Low", value: "25.53")
        addStat(title: "High", value: "29.70")
        addStat(title: "Volume", value: "19.33m")
        addStat(title: "Mkt Cap", value: "454.5m")
    }
    
    func addStat(title:String, value:String) {
        let statView = StatView(title: title, value: value)
        stackView.addArrangedSubview(statView)
    }
}

class StatView:UIView {
    var titleLabel:UILabel!
    var valueLabel:UILabel!
    
    let title:String
    var value:String
    init(title:String, value:String) {
        self.title = title
        self.value = value
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setup() {
        let stackView = UIStackView()
        stackView.axis = .vertical

        addSubview(stackView)
        stackView.constraintToSuperview()
        stackView.spacing = 3.0
        
        titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        titleLabel.textColor = UIColor.secondaryLabel
        //titleLabel.textAlignment = .center
        stackView.addArrangedSubview(titleLabel)
        
        valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.textColor = UIColor.label
        valueLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        //valueLabel.textAlignment = .center
        stackView.addArrangedSubview(valueLabel)
        
    }
}

