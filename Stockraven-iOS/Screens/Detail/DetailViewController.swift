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
    
    init(stock:Stock) {
        self.stock = stock
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
        navigationController?.navigationBar.tintColor = Theme.current.primary
        tableView.register(DetailHeaderCell.self, forCellReuseIdentifier: "headerCell")
        tableView.register(DetailQuoteCell.self, forCellReuseIdentifier: "quoteCell")
        tableView.register(DetailKeyStatsCell.self, forCellReuseIdentifier: "statsCell")
        tableView.register(StockTitleHeaderCell.self, forCellReuseIdentifier: "titleCell")
        tableView.register(AlertSummaryCell.self, forCellReuseIdentifier: "alertsCell")
        tableView.register(NotesSummaryCell.self, forCellReuseIdentifier: "notesCell")
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0)
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
        self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 1
        case 2:
            return 1
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
                let cell = tableView.dequeueReusableCell(withIdentifier: "alertsCell", for: indexPath) as! AlertSummaryCell
                cell.configure(stock)
                cell.delegate = self
                //cell.delegate = self
                //cell.titleLabel.text = "Alerts"
                return cell
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "notesCell", for: indexPath) as! NotesSummaryCell
                return cell
            default:
                break
            }
        default:
            break
        }
        
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension DetailViewController:AlertsSummaryDelegate {
    func alertsSummaryAddAlert() {
        let alertVC = AlertViewController(stock: stock)
        let navVC = UINavigationController(rootViewController: alertVC)
        self.present(navVC, animated: true, completion: nil)
    }
    
    func alertsSummary(didSelect alert: Alert) {
        let alertVC = AlertViewController(stock: stock, alert: alert)
        let navVC = UINavigationController(rootViewController: alertVC)
        self.present(navVC, animated: true, completion: nil)
    }
}
