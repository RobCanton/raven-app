//
//  NewsCell.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-05.
//

import Foundation
import UIKit


class NewsCell:UITableViewCell {
    private var stackView:UIStackView!
    private var sourceLabel:UILabel!
    private var titleLabel:UILabel!
    private var bodyLabel:UILabel!
    private var timeLabel:UILabel!
    
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
        stackView.axis = .vertical
        stackView.spacing = 4
        contentView.addSubview(stackView)
        stackView.constraintToSuperview(16, 16, 16, 16, ignoreSafeArea: false)
        
        sourceLabel = UILabel()
        sourceLabel.numberOfLines = 1
        sourceLabel.textColor = .secondaryLabel
        sourceLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .label
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        
        bodyLabel = UILabel()
        bodyLabel.numberOfLines = 1
        bodyLabel.textColor = .secondaryLabel
        bodyLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        timeLabel = UILabel()
        timeLabel.numberOfLines = 1
        timeLabel.textColor = .secondaryLabel
        timeLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
       
        
        
        stackView.addArrangedSubview(sourceLabel)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(bodyLabel)
        stackView.addArrangedSubview(timeLabel)
    }
    
    func setup(withNews news:News) {
        sourceLabel.text = news.source
        titleLabel.text = news.headline
        bodyLabel.text = news.summary
        if let dateStr = news.date?.timeSinceNow() {
            timeLabel.text = dateStr
        } else {
            timeLabel.text = ""
        }
        
    }
    
}

