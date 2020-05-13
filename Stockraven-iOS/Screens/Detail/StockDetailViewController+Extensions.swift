//
//  StockDetailViewController+Extensions.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-06.
//

import Foundation
import UIKit


extension StockDetailViewController: TabHeaderDelegate {
    func tabHeader(didSelect index: Int) {
        self.selectedHeaderIndex = index
        let sections = numberOfSections(in: self.tableView)
        self.tableView.reloadData()
        //self.tableView.reloadSections(IndexSet(1..<sections), with: .automatic)
    }
}

extension StockDetailViewController: AlertCellDelegate {
    func alertCell(didSelect action: AlertCell.Action, index: Int) {
        let alert = alerts[index]
        switch action {
        case .mute:
            break
        case .edit:
            let alertVC = AlertViewController(stock: stock, alert: alert)
            let navVC = UINavigationController(rootViewController: alertVC)
            self.present(navVC, animated: true, completion: nil)
            break
        case .follow:
            break
        }
    }
}
