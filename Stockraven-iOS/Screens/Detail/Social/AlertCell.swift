//
//  AlertCell.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-06.
//

import Foundation
import UIKit

protocol AlertCellDelegate:class {
    func alertCell(didSelect action:AlertCell.Action, index:Int)
}

class AlertCell:UITableViewCell {
    
    public enum Action {
        case mute, edit, follow
    }
    
    var index:Int?
    weak var delegate:AlertCellDelegate?
    
    private var titleLabel:UILabel!
    private var bodyLabel:UILabel!
    private var buttonsRow:UIStackView!
    private var bubbleView:UIView!
    
    
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
        bubbleView = UIView()
        contentView.addSubview(bubbleView)
        bubbleView.constraintToSuperview(16, 16, 0, 16, ignoreSafeArea: false)
        bubbleView.backgroundColor = UIColor.secondarySystemGroupedBackground
        bubbleView.layer.cornerRadius = 12
        bubbleView.layer.cornerCurve = .continuous
        bubbleView.clipsToBounds = true
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        bubbleView.addSubview(stackView)
        stackView.constraintToSuperview(12, 12, nil, 12, ignoreSafeArea: false)
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .label
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        bodyLabel = UILabel()
        bodyLabel.numberOfLines = 1
        bodyLabel.textColor = .secondaryLabel
        bodyLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(bodyLabel)
        
        titleLabel.text = "Price is over 80.00"
        bodyLabel.text = "Customize message..."
        
        buttonsRow = UIStackView()
        buttonsRow.axis = .horizontal
        buttonsRow.distribution = .fillEqually
        buttonsRow.spacing = 12
        bubbleView.addSubview(buttonsRow)
        buttonsRow.constraintToSuperview(nil, 12, 12, 12, ignoreSafeArea: false)
        buttonsRow.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 12).isActive = true
        buttonsRow.constraintHeight(to: 44)
        
        let muteButton = UIButton()
        muteButton.setTitle("Mute", for: .normal)
        muteButton.titleLabel?.textAlignment = .center
        muteButton.setTitleColor(.secondaryLabel, for: .normal)
        muteButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        muteButton.setImage(UIImage(systemName: "bell.slash"), for: .normal)
        muteButton.imageView?.tintColor = UIColor.secondaryLabel
        muteButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        muteButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        muteButton.backgroundColor = UIColor.secondarySystemFill
        muteButton.layer.cornerRadius = 12
        muteButton.layer.cornerCurve = .continuous
        muteButton.clipsToBounds = true
        muteButton.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        muteButton.tag = 0
        
        let editButton = UIButton()
        editButton.setTitle("Edit", for: .normal)
        editButton.titleLabel?.textAlignment = .center
        editButton.titleLabel?.textColor = .secondaryLabel
        editButton.setTitleColor(.secondaryLabel, for: .normal)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        editButton.imageView?.tintColor = UIColor.secondaryLabel
        editButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        editButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        editButton.backgroundColor = UIColor.secondarySystemFill
        editButton.layer.cornerRadius = 12
        editButton.layer.cornerCurve = .continuous
        editButton.clipsToBounds = true
        editButton.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        editButton.tag = 1
        
        let followButton = UIButton()
        followButton.setTitle("Unfollow", for: .normal)
        followButton.titleLabel?.textAlignment = .center
        followButton.titleLabel?.textColor = .secondaryLabel
        followButton.setTitleColor(.secondaryLabel, for: .normal)
        followButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        followButton.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        followButton.imageView?.tintColor = UIColor.secondaryLabel
        followButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        followButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        followButton.backgroundColor = UIColor.secondarySystemFill
        followButton.layer.cornerRadius = 12
        followButton.layer.cornerCurve = .continuous
        followButton.clipsToBounds = true
        followButton.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        followButton.tag = 2
        
        buttonsRow.addArrangedSubview(muteButton)
        buttonsRow.addArrangedSubview(editButton)
        //buttonsRow.addArrangedSubview(followButton)
        
    }
    
    func setup(withAlert alert:Alert, index:Int) {
        self.index = index
        titleLabel.text = alert.stringRepresentation
    }
    
    @objc func handleButton(_ button:UIButton) {
        guard let index = index else { return }
        switch button.tag {
        case 0:
            delegate?.alertCell(didSelect: .mute, index: index)
            break
        case 1:
            delegate?.alertCell(didSelect: .edit, index: index)
            break
        case 2:
            delegate?.alertCell(didSelect: .follow, index: index)
            break
        default:
            break
        }
    }
    
}


