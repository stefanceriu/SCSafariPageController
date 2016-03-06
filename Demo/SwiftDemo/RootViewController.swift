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
        self.view.insertSubview(self.safariPageController.view, atIndex: 0)
        self.safariPageController.didMoveToParentViewController(self)
        
        self.addButton.alpha = 0.0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
        self.safariPageController.zoomOutAnimated(true, completion: nil)
    }
    
    func numberOfPagesInPageController(pageController: SCSafariPageController!) -> UInt {
        return UInt(self.dataSource.count)
    }
    
    func pageController(pageController: SCSafariPageController!, viewControllerForPageAtIndex index: UInt) -> UIViewController! {
        
        var viewController = self.dataSource[Int(index)]
        
        if viewController == nil {
            viewController = ViewController()
            viewController?.delegate = self
            self.dataSource[Int(index)] = viewController
        }
        
        viewController?.setHeaderVisible(self.safariPageController.isZoomedOut, animated: false)
        
        return viewController
    }
    
    func pageController(pageController: SCSafariPageController!, willDeletePageAtIndex pageIndex: UInt) {
        self.dataSource.removeAtIndex(Int(pageIndex))
    }
    
    // MARK: SCViewControllerDelegate
    
    func viewControllerDidReceiveTap(viewController: ViewController) {
        if !self.safariPageController.isZoomedOut {
            return
        }
        
        let pageIndex = self.dataSource.indexOf{$0 === viewController}
        
        self.toggleZoomWithPageIndex(UInt(pageIndex!))
    }
    
    func viewControllerDidRequestDelete(viewController: ViewController) {
        let pageIndex = self.dataSource.indexOf{$0 === viewController}!
        
        self.dataSource.removeAtIndex(pageIndex)
        self.safariPageController.deletePagesAtIndexes(NSIndexSet(index: pageIndex), animated: true, completion: nil)
    }
    
    // MARK: Private
    
    private func toggleZoomWithPageIndex(pageIndex:UInt) {
        if self.safariPageController.isZoomedOut {
            self.safariPageController.zoomIntoPageAtIndex(pageIndex, animated: true, completion: nil)
        } else {
            self.safariPageController.zoomOutAnimated(true, completion: nil)
        }
        
        for viewController in self.dataSource {
            viewController?.setHeaderVisible(self.safariPageController.isZoomedOut, animated: true)
        }
        
        UIView.animateWithDuration(0.25) { () -> Void in
            self.addButton.alpha = (self.safariPageController.isZoomedOut ? 1.0 : 0.0)
        }
    }
    
    @IBAction private func onZoomButtonTap(sender:UIButton) {
        self.toggleZoomWithPageIndex(self.safariPageController.currentPage)
    }
    
    @IBAction private func onAddButtonTap(sender:UIButton) {
        self.dataSource.insert(nil, atIndex: Int(self.safariPageController.numberOfPages))
        self.safariPageController.insertPagesAtIndexes(NSIndexSet(index: Int(self.safariPageController.numberOfPages)), animated: true) { () -> Void in
            self.toggleZoomWithPageIndex(self.safariPageController.numberOfPages - 1)
        }
    }
}

