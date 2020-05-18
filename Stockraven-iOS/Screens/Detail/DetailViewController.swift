//
//  DetailViewController.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-14.
//

import Foundation
import UIKit
import JJFloatingActionButton


class DetailViewController:UITableViewController {
    var stock:Stock
    
    let info = [
        ("Market cap", "12.24B"),
        ("P/E ratio", "3.56"),
        ("Dividend", "1.15"),
        ("Dividend yield","8.39%"),
        ("52 week high", "63.44"),
        ("52 week low", "17.51")
    ]
    
    var alerts:[Alert]
    
    init(stock:Stock) {
        self.stock = stock
        self.alerts = StockManager.shared.alerts(for: stock.symbol)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = true
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = stock.symbol
//        let addButton =
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
        tableView.register(DetailHeaderCell.self, forCellReuseIdentifier: "headerCell")
        tableView.register(DetailQuoteCell.self, forCellReuseIdentifier: "quoteCell")
        tableView.register(DetailKeyStatsCell.self, forCellReuseIdentifier: "statsCell")
        tableView.register(StockTitleHeaderCell.self, forCellReuseIdentifier: "titleCell")
        tableView.register(AlertRow.self, forCellReuseIdentifier: "alertCell")
        tableView.register(CommentsSummaryCell.self, forCellReuseIdentifier: "commentsCell")
        tableView.register(InfoCell.self, forCellReuseIdentifier: "infoCell")
        tableView.register(SimilarSummaryCell.self, forCellReuseIdentifier: "similarCell")
        tableView.register(GapCell.self, forCellReuseIdentifier: "gapCell")
        
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        //tableView.separatorStyle = .none
        tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.addObserver(self, selector: #selector(alertsUpdated), type: .alertsUpdated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleAdd() {
        let alertSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertSheet.addAction(UIAlertAction(title: "New Alert", style: .default, handler: { _ in
            
        }))
        alertSheet.addAction(UIAlertAction(title: "New Note", style: .default, handler: { _ in
            
        }))
        
        alertSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertSheet, animated: true, completion: nil)
    }
    
    @objc func alertsUpdated() {
        self.alerts = StockManager.shared.alerts(for: stock.symbol)
        self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1 + alerts.count + 1
        case 2:
            return 1 + 1
        case 3:
            return 1 + info.count
        case 4:
            return 1 + 1
        default:
            return 0
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! DetailHeaderCell
                cell.configure(stock: stock)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "quoteCell", for: indexPath) as! DetailQuoteCell
                //cell.separatorInset = .zero
                cell.configure(stock: stock)
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "statsCell", for: indexPath) as! DetailKeyStatsCell
                cell.separatorInset = .zero
                return cell
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath) as! StockTitleHeaderCell
                cell.titleLabel.text = "My Alerts"
                cell.button.setTitle(nil, for: .normal)
                cell.button.setImage(UIImage(systemName: "plus", withConfiguration: nil), for: .normal)
                cell.button.addTarget(self, action: #selector(handleNewAlert), for: .touchUpInside)
                return cell
            case alerts.count + 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "gapCell", for: indexPath) as! GapCell
                cell.backgroundColor = UIColor.blue
                cell.textLabel?.text = "asd"
                cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "alertCell", for: indexPath) as! AlertRow
                if indexPath.row == alerts.count {
                    cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
                } else {
                    cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
                }
                return cell
            }
        case 2:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath) as! StockTitleHeaderCell
                cell.titleLabel.text = "Discussion"
                cell.button.setTitle("See All", for: .normal)
                cell.button.setImage(nil, for: .normal)
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "commentsCell", for: indexPath) as! CommentsSummaryCell
                return cell
            }
        case 3:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath) as! StockTitleHeaderCell
                cell.titleLabel.text = "Information"
                cell.button.setTitle("", for: .normal)
                cell.button.setImage(nil, for: .normal)
                return cell
            default:
                let i = info[indexPath.row - 1]
                let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! InfoCell
                cell.textLabel?.text = i.0
                cell.detailTextLabel?.text = i.1
                return cell
            }
        case 4:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath) as! StockTitleHeaderCell
                cell.titleLabel.text = "Related Stocks"
                cell.button.setTitle(nil, for: .normal)
                cell.button.setImage(nil, for: .normal)
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "similarCell", for: indexPath) as! SimilarSummaryCell
                return cell
            }
        default:
            break
        }
        
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let quoteCell = cell as? DetailQuoteCell {
            quoteCell.updateQuoteDisplay()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 1:
            if indexPath.row > 0 {
                let alert = alerts[indexPath.row-1]
                let alertVC = AlertViewController(stock: stock, alert: alert)
                let navVC = UINavigationController(rootViewController: alertVC)
                self.present(navVC, animated: true, completion: nil)
            }
            break
        default:
            break
        }
    }
    
    @objc func handleNewAlert() {
        let alertVC = AlertViewController(stock: stock)
        let navVC = UINavigationController(rootViewController: alertVC)
        self.present(navVC, animated: true, completion: nil)
    }
    
}

extension DetailViewController:NotesSummaryDelegate {
    func notesSummaryAddNote() {
        let noteVC = NoteViewController()
        let navVC = UINavigationController(rootViewController: noteVC)
        self.present(navVC, animated: true, completion: nil)
    }
    
    
}
