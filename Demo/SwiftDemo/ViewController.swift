//
//  ViewController.swift
//  SwiftDemo
//
//  Created by Stefan Ceriu on 20/02/2016.
//  Copyright © 2016 Stefan Ceriu. All rights reserved.
//

import UIKit

@objc protocol ViewControllerDelegate {
    @objc optional func viewControllerDidReceiveTap(_ viewController:ViewController)
    @objc optional func viewControllerDidRequestDelete(_ viewController:ViewController)
}

class ViewController: UIViewController {

    var delegate:ViewControllerDelegate?
    
    @IBOutlet var contentView:UIView!
    @IBOutlet var backgroundImageView:UIImageView!
    @IBOutlet var deleteButton:UIButton!
    
    var headerVisible:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.onBackgroundTap(_:)))
        self.backgroundImageView.addGestureRecognizer(tapGesture)
    }

    func setHeaderVisible(_ visible:Bool, animated:Bool) {
        self.headerVisible = visible
        
        if self.isViewLoaded == false {
            return
        }
        
        UIView.animate(withDuration: (animated ? 0.25 : 0.0), animations: {
            self.deleteButton?.alpha = (visible ? 1.0 : 0.0)
        })
    }
    
    @IBAction fileprivate func onDeleteButtonTap(_ sender:UIButton) {
        self.delegate?.viewControllerDidRequestDelete?(self)
    }
    
    func onBackgroundTap(_ tapGesture:UITapGestureRecognizer) {
        self.delegate?.viewControllerDidReceiveTap?(self)
    }
}

class ViewControllerView: UIView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        
        if hitView == self {
            return nil
        }
        
        return hitView
    }
}
