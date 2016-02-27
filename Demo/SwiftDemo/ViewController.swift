//
//  ViewController.swift
//  SwiftDemo
//
//  Created by Stefan Ceriu on 20/02/2016.
//  Copyright © 2016 Stefan Ceriu. All rights reserved.
//

import UIKit

@objc protocol ViewControllerDelegate {
    optional func viewControllerDidReceiveTap(viewController:ViewController)
    optional func viewControllerDidRequestDelete(viewController:ViewController)
}

class ViewController: UIViewController {

    var delegate:ViewControllerDelegate?
    
    @IBOutlet var contentView:UIView!
    @IBOutlet var backgroundImageView:UIImageView!
    @IBOutlet var deleteButton:UIButton!
    
    var headerVisible:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("onBackgroundTap:"))
        self.backgroundImageView.addGestureRecognizer(tapGesture)
    }

    func setHeaderVisible(visible:Bool, animated:Bool) {
        self.headerVisible = visible
        
        if self.viewIfLoaded == false {
            return
        }
        
        UIView.animateWithDuration((animated ? 0.25 : 0.0), animations: {
            self.deleteButton?.alpha = (visible ? 1.0 : 0.0)
        })
    }
    
    @IBAction private func onDeleteButtonTap(sender:UIButton) {
        self.delegate?.viewControllerDidRequestDelete?(self)
    }
    
    func onBackgroundTap(tapGesture:UITapGestureRecognizer) {
        self.delegate?.viewControllerDidReceiveTap?(self)
    }
}

class ViewControllerView: UIView {
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, withEvent: event)
        
        if hitView == self {
            return nil
        }
        
        return hitView
    }
}
