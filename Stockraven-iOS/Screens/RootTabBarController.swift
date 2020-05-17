//
//  RootTabBarController.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-02.
//

import Foundation
import UIKit
import SwiftMessages

enum Screen:String {
    case home = "home"
    case stock = "stock"
}

enum Action:Int {
    case add = 1
    case edit = 2
}

class RootTabBarController:UITabBarController {
    
    var screen:Screen = .home
    let homeVC:HomeViewController
    let notificationsVC:NotificationsViewController
    let settingsVC:UserViewController
    var sideMenu:UIView!
    
    init() {
        homeVC = HomeViewController()
        notificationsVC = NotificationsViewController()
        settingsVC = UserViewController()
        super.init(nibName: nil, bundle: nil)
        
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem.image = UIImage(systemName: "house.fill")
        homeNav.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let notificationsNav = UINavigationController(rootViewController: notificationsVC)
        notificationsNav.tabBarItem.image = UIImage(systemName: "app.badge")
        notificationsNav.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let settingsNav = UINavigationController(rootViewController: settingsVC)
        settingsNav.tabBarItem.image = UIImage(systemName: "person.crop.circle")
        settingsNav.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        setViewControllers([
            homeNav, notificationsNav, settingsNav
        ], animated: false)
        
        sideMenu = UIView()
        sideMenu.backgroundColor = UIColor.systemOrange
        view.addSubview(sideMenu)
        sideMenu.trailingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        sideMenu.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
        sideMenu.constraintToSuperview(0, nil, 0, nil, ignoreSafeArea: true)
        
        let button = UIButton()
        button.setTitle("hello", for: .normal)
        sideMenu.addSubview(button)
        button.constraintToCenter(axis: [.x,.y])
        button.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        
        view.clipsToBounds = false
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc func handleButton() {
        print("heyo!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor.label
        tabBar.isTranslucent = false
        
//        tabBar.setItems([
//            UITabBarItem(title: nil, image: UIImage(named: "chart"), tag: 0)
//        ], animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.addObserver(self, selector: #selector(showSideMenu), type: .showSideMenu)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func presentAlert() {
        let random = Double.random(in: 5...8)
        DispatchQueue.main.asyncAfter(deadline: .now() + random, execute: {
            let view: MessageView
            view = MessageView.viewFromNib(layout: .cardView)
            //view.backgroundColor = UIColor.systemBlue
            view.configureContent(title: "TSLA",
                                  body: "TSLA",
                                  iconImage: nil,
                                  iconText: nil,
                                  buttonImage: nil,
                                  buttonTitle: nil,
                                  buttonTapHandler: { _ in SwiftMessages.hide() })
            view.configureTheme(backgroundColor: UIColor.systemBlue, foregroundColor: .label)
            /*view.titleLabel?.textColor = UIColor.label
            view.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            view.bodyLabel?.textColor = UIColor.label
            view.bodyLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)*/
            view.titleLabel?.attributedText = NSAttributedString(string: "TSLA  -  720.45", attributes: [
                 NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0, weight: .bold)
            ])
            
            let attributedBodyText = NSMutableAttributedString()
//            attributedBodyText.append(NSAttributedString(string: "720.45",
//                                                         attributes: [
//                                                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0, weight: .semibold)
//            ]))
//
            attributedBodyText.append(NSAttributedString(string: "Price over 700",
                                                         attributes: [
                                                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0, weight: .regular)
            ]))
            view.bodyLabel?.attributedText = attributedBodyText
            view.button?.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            view.button?.tintColor = UIColor.white
            view.button?.backgroundColor = UIColor.clear
            view.tapHandler = { _ in
                /*let stock = StockManager.shared.stocks.first!
                let stockVC = StockDetailViewController(stock: stock)
                guard let first = self.viewControllers?.first as? UINavigationController else { return }
                first.pushViewController(stockVC, animated: true)*/
                SwiftMessages.hide()
            }
            
            var config = SwiftMessages.defaultConfig
            config.presentationStyle = .top
            config.presentationContext = .window(windowLevel: .normal)
            config.duration = .seconds(seconds: 5)
            config.interactiveHide = true
            
            SwiftMessages.show(config: config, view: view)
            self.presentAlert()
        })
    }
    
    
    @objc func showSideMenu() {
        var frame = view.frame
        frame.origin.x = view.bounds.width * 0.75
        
        let animator = UIViewPropertyAnimator(duration: 0.3, timingParameters: Easings.Cubic.easeOut)
        animator.addAnimations {
            self.view.frame = frame
        }
        
        animator.startAnimation()
       
    }
    
   
}

