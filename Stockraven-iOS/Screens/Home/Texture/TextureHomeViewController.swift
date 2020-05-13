//
//  TextureHomeViewController.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-07.
//

import Foundation
import UIKit
import AsyncDisplayKit

class TextureHomeViewController:ASViewController<ASDisplayNode>, ASTableDelegate, ASTableDataSource {
    
    var stocks:[Stock] {
        return StockManager.shared.stocks
    }
    
    var tableNode:ASTableNode {
        return node as! ASTableNode
    }
    var tableView:UITableView {
        return tableNode.view as UITableView
    }
    
    var searchController:UISearchController!
    var searchResultsVC:TickerSearchResultsController!
    
    init() {
        super.init(node: ASTableNode())
        tableNode.delegate = self
        tableNode.dataSource = self
        
        tableNode.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Trading Hours"
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
        searchController.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.hidesNavigationBarDuringPresentation = true
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        tableNode.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0)
        
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
        
        tableNode.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stocksUpdated()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func stocksUpdated() {
        NotificationCenter.default.removeObserver(self)
        //self.stocks = StockManager.shared.stocks
        
        self.tableNode.reloadData()
        
        
        NotificationCenter.addObserver(self, selector: #selector(stocksUpdated), type: .stocksUpdated)
        for stock in stocks {
            NotificationCenter.addObserver(self, selector: #selector(stockTradeUpdate), type: .stockTradeUpdated(stock.symbol))
            NotificationCenter.addObserver(self, selector: #selector(stockQuoteUpdate), type: .stockQuoteUpdated(stock.symbol))
        }
    }
    
    
    @objc func stockTradeUpdate(_ notification:Notification) {
        guard let stock = notification.userInfo?["stock"] as? Stock else { return }
        
        
        guard let index = stocks.firstIndex(where: { _stock in
            return _stock.symbol == stock.symbol
        }) else { return }
        
        
        
//        for node in tableNode.visibleNodes {
//            if let stocknode = node as? StockCellNode,
//                stocknode.stock.symbol == stock.symbol {
//                stocknode.updateTrade(stock)
//            }
//        }
        
        guard let node = tableNode.nodeForRow(at: IndexPath(row: index, section: 0)) as? StockCellNode else { return }
        if stock.symbol == "TSLA" {
            print("TSLA index: \(index)")
        }
        if node.isVisible {
            if stock.symbol == "TSLA" {
                print("TSLA visible")
            }
            //if node.stock.symbol == stock.symbol {
                node.updateTrade(stock)
                if stock.symbol == "TSLA" {
                    print("TSLA updatetrade")
                }
            //}
        }
        
    }
    
    @objc func stockQuoteUpdate(_ notification:Notification) {
        guard let stock = notification.userInfo?["stock"] as? Stock else { return }
        
        
        guard let index = stocks.firstIndex(where: { _stock in
            return _stock.symbol == stock.symbol
        }) else { return }
        
        guard let node = tableNode.nodeForRow(at: IndexPath(row: index, section: 0)) as? StockCellNode else { return }
//        for node in tableNode.visibleNodes {
//            if let stocknode = node as? StockCellNode,
//                stocknode.stock.symbol == stock.symbol {
//                stocknode.updateQuote(stock)
//            }
//        }
        if node.isVisible {
            //if node.stock.symbol == stock.symbol {
                node.updateQuote(stock)
            //}
        }
        
    }
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }
    
    /*func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let node = StockCellNode(stock: stocks[indexPath.row])
        return node
    }*/
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let stock = stocks[indexPath.row]
        let cellNodeBlock = { () -> ASCellNode in
          let cellNode = StockCellNode(stock: stock)
          //cellNode.delegate = self
          return cellNode
        }
          
        return cellNodeBlock
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //let movingItem = stocks[sourceIndexPath.row]
        //stocks.remove(at: sourceIndexPath.row)
//        /stocks.insert(movingItem, at: destinationIndexPath.row)
        
        StockManager.shared.moveStock(at: sourceIndexPath.row, to: destinationIndexPath.row)
//        /stocks = StockManager.shared.stocks
        
    }
    
}

extension TextureHomeViewController: UITableViewDragDelegate, UITableViewDropDelegate {
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

extension TextureHomeViewController: UISearchControllerDelegate, TickerSearchDelegate {
    
    func willPresentSearchController(_ searchController: UISearchController) {
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.alpha = 0.25
        })
        
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.alpha = 1.0
        })
    }
    
    func tickerSearch(didSelect ticker: Ticker) {
        StockManager.shared.subscribe(to: ticker.symbol)
        searchController.isActive = false
    }
}
