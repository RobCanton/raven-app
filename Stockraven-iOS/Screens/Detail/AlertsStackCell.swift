//
//  AlertsStackCell.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-14.
//

import Foundation
import UIKit


protocol AlertsStackDelegate:class {
    func alertsStack(didSelect alert:Alert)
}

class AlertsStackCell:UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate:AlertsStackDelegate?
    var alerts = [Alert]()
    var stackView:UIStackView!
    var tableView:UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        tableView = UITableView(frame: .zero, style: .plain)
        contentView.addSubview(tableView)
        tableView.constraintToSuperview()
        tableView.register(AlertRow.self, forCellReuseIdentifier: "cell")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 36 + 12, bottom: 0, right: 16)
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func configure(_ alerts:[Alert]) {
        self.alerts = alerts
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alerts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AlertRow
        cell.titleLabel.text = alerts[indexPath.row].stringRepresentation
        if indexPath.row == alerts.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 36 + 12, bottom: 0, right: 16)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.alertsStack(didSelect: alerts[indexPath.row])
    }
    
}

class AlertRow: UITableViewCell {
    var typeBubble:UIView!
    var typeLabel:UILabel!
    var typeIcon:UIImageView!
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
        self.selectionStyle = .none
        //self.constraintHeight(to: 44 + 8)
        //self.backgroundColor = UIColor.label.withAlphaComponent(0.05)
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 8
        self.layer.cornerCurve = .continuous
        self.clipsToBounds = true
        typeBubble = UIView()
        addSubview(typeBubble)
        typeBubble.constraintToSuperview(8, 0, 8, nil, ignoreSafeArea: true)
        typeBubble.layer.cornerRadius = 8
        typeBubble.layer.cornerCurve = .continuous
        typeBubble.clipsToBounds = true
        typeBubble.backgroundColor = Theme.current.positive
        typeBubble.widthAnchor.constraint(equalTo: typeBubble.heightAnchor, multiplier: 1.0).isActive = true
        
        typeLabel = UILabel()
        typeLabel.text = ""
        typeLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        typeBubble.addSubview(typeLabel)
        typeLabel.constraintToCenter(axis: [.x,.y])
        
        typeIcon = UIImageView()
        typeIcon.image = UIImage(systemName: "arrow.up.right")
        typeIcon.tintColor = UIColor.white
        typeIcon.contentMode = .scaleAspectFit
        typeBubble.addSubview(typeIcon)
        typeIcon.constraintToSuperview(6, 6, 6, 6, ignoreSafeArea: true)
    
        
        titleLabel = UILabel()
        titleLabel.text = "Price is over 12.5"
        addSubview(titleLabel)
        titleLabel.constraintToSuperview(nil, nil, nil, 12, ignoreSafeArea: true)
        titleLabel.leadingAnchor.constraint(equalTo: typeBubble.trailingAnchor, constant: 12).isActive = true
        titleLabel.constraintToCenter(axis: [.y])
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if isHighlighted {
            UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
                self.alpha = 0.5
            }, completion: nil)
        } else {
            self.alpha = 0.5
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
                self.alpha = 1.0
            }, completion: nil)
        }
    }
}
