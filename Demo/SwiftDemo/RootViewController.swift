//
//  RootViewController.swift
//  SwiftDemo
//
//  Created by Stefan Ceriu on 16/02/2016.
//  Copyright © 2016 Stefan Ceriu. All rights reserved.
//

import UIKit
import SCSafariPageController

class RootViewController: UIViewController, SCSafariPageControllerDataSource, SCSafariPageControllerDelegate, ViewControllerDelegate {
    
    let kDefaultNumberOfPages = 5
    var dataSource = Array<ViewController?>()
    let safariPageController:SCSafariPageController = SCSafariPageController()
    
    @IBOutlet var zoomButton:UIButton!
    @IBOutlet var addButton:UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        for _ in 1...kDefaultNumberOfPages {
            self.dataSource.append(nil)
        }
        
        self.safariPageController.dataSource = self
        self.safariPageController.delegate = self
        
        self.addChildViewController(self.safariPageController)
        self.safariPageController.view.frame = self.view.bounds
        self.view.insertSubview(self.safariPageController.view, at: 0)
        self.safariPageController.didMove(toParentViewController: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        self.safariPageController.zoomOut(animated: true, completion: nil)
    }
    
    func numberOfPages(in pageController: SCSafariPageController!) -> UInt {
        return UInt(self.dataSource.count)
    }
    
    func pageController(_ pageController: SCSafariPageController!, viewControllerForPageAt index: UInt) -> UIViewController! {
        
        var viewController = self.dataSource[Int(index)]
        
        if viewController == nil {
            viewController = ViewController()
            viewController?.delegate = self
            self.dataSource[Int(index)] = viewController
        }
        
        viewController?.setHeaderVisible(self.safariPageController.isZoomedOut, animated: false)
        
        return viewController
    }
    
    func pageController(_ pageController: SCSafariPageController!, willDeletePageAt pageIndex: UInt) {
        self.dataSource.remove(at: Int(pageIndex))
    }
    
    // MARK: SCViewControllerDelegate
    
    func viewControllerDidReceiveTap(_ viewController: ViewController) {
        if !self.safariPageController.isZoomedOut {
            return
        }
        
        let pageIndex = self.dataSource.index{$0 === viewController}
        
        self.toggleZoomWithPageIndex(UInt(pageIndex!))
    }
    
    func viewControllerDidRequestDelete(_ viewController: ViewController) {
        let pageIndex = self.dataSource.index{$0 === viewController}!
        
        self.dataSource.remove(at: pageIndex)
        self.safariPageController.deletePages(at: IndexSet(integer: pageIndex), animated: true, completion: nil)
    }
    
    // MARK: Private
    
    fileprivate func toggleZoomWithPageIndex(_ pageIndex:UInt) {
        if self.safariPageController.isZoomedOut {
            self.safariPageController.zoomIntoPage(at: pageIndex, animated: true, completion: nil)
        } else {
            self.safariPageController.zoomOut(animated: true, completion: nil)
        }
        
        for viewController in self.dataSource {
            viewController?.setHeaderVisible(self.safariPageController.isZoomedOut, animated: true)
        }
        
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.addButton.alpha = (self.safariPageController.isZoomedOut ? 1.0 : 0.0)
        }) 
    }
    
    @IBAction fileprivate func onZoomButtonTap(_ sender:UIButton) {
        self.toggleZoomWithPageIndex(self.safariPageController.currentPage)
    }
    
    @IBAction fileprivate func onAddButtonTap(_ sender:UIButton) {
        self.dataSource.insert(nil, at: Int(self.safariPageController.numberOfPages))
        self.safariPageController.insertPages(at: IndexSet(integer: Int(self.safariPageController.numberOfPages)), animated: true) { () -> Void in
            self.toggleZoomWithPageIndex(self.safariPageController.numberOfPages - 1)
        }
    }
}

