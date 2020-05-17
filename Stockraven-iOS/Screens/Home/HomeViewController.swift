//
//  HomeViewController.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-02.
//

import Foundation
import UIKit
import SwiftUI


class HomeViewController:UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView:UITableView!
    
    var searchController:UISearchController!
    var searchResultsVC:TickerSearchResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        tableView = UITableView()
        view.addSubview(tableView)
        tableView.constraintToSuperview(0, 0, 49, 0, ignoreSafeArea: true)
        
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.title = StockManager.shared.marketStatus.displayString
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = UIColor.systemBackground
        navigationController?.navigationBar.tintColor = UIColor.label
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back",
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
        
        searchResultsVC = TickerSearchResultsController()
        searchResultsVC.delegate = self
        
        searchController = UISearchController(searchResultsController: searchResultsVC)
        searchController.searchBar.delegate = searchResultsVC
        searchController.searchBar.autocapitalizationType = .allCharacters
        searchController.searchBar.autocorrectionType = .no
        searchController.automaticallyShowsScopeBar = true
        searchController.searchBar.scopeButtonTitles = ["Stocks", "Forex", "Crypto"]
        //searchController.searchBar.scope
        searchController.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.hidesNavigationBarDuringPresentation = true
        
        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(showSideMenu))
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        tableView.register(StockCell.self, forCellReuseIdentifier: "cell")
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
        
        stocksUpdated()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stocksUpdated()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func showSideMenu() {
        NotificationCenter.post(.showSideMenu)
    }
    @objc func stocksUpdated() {
        self.tableView.reloadData()
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.addObserver(self, selector: #selector(stocksUpdated), type: .stocksUpdated)
        NotificationCenter.addObserver(self, selector: #selector(marketStatusUpdated), type: .marketStatusUpdated)
    }
    
    @objc func marketStatusUpdated() {
        print("marketStatusUpdated")
        navigationItem.title = StockManager.shared.marketStatus.displayString
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StockManager.shared.stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StockCell
        let stock = StockManager.shared.stocks[indexPath.row]
        cell.configure(stock: stock)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //let pageVC = StockDetailPageViewController(startIndex: indexPath.row)
        let stock = StockManager.shared.stocks[indexPath.row]
        //let detailVC = StockDetailViewController(stock: stock)
        //let detailVC = ParallaxStockViewController()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let detailVC = storyboard.instantiateViewController(identifier: "ParallaxStockDetail") as! ParallaxStockViewController
        //detailVC.stock = stock
        let detailVC = DetailViewController(stock: stock)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        //let movingItem = stocks.remove(at: sourceIndexPath.row)
        //stocks.insert(movingItem, at: destinationIndexPath.row)
        StockManager.shared.moveStock(at: sourceIndexPath.row, to: destinationIndexPath.row)
        //stocks = StockManager.shared.stocks
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let stock = StockManager.shared.stocks[indexPath.row]
            StockManager.shared.unsubscribe(from: stock.symbol)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}


extension HomeViewController: UITableViewDragDelegate, UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {

        if session.localDragSession != nil { // Drag originated from the same app.
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }

        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
    }
}

extension HomeViewController: UISearchControllerDelegate, TickerSearchDelegate {
    
    func willPresentSearchController(_ searchController: UISearchController) {
        print("willPresentSearchController")
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.alpha = 0.25
        })
        
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        print("willDismissSearchController")
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.alpha = 1.0
        })
    }
    
    func tickerSearch(didSelect ticker: Ticker) {
        StockManager.shared.subscribe(to: ticker.symbol)
        searchController.isActive = false
    }
}



