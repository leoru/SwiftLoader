//
//  ViewController.swift
//  SwiftLoaderExample
//
//  Created by Kirill Kunst on 11.02.15.
//  Copyright (c) 2015 Kirill Kunst. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    func delay(#seconds: Double, completion:()->()) {
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
        
        dispatch_after(popTime, dispatch_get_main_queue()) {
            completion()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red:0.88, green:0.9, blue:0.92, alpha:1)
        self.addButton()
    }
    
    func addButton() {
        let size : CGFloat = 200.0
        var actionButton = UIButton(frame: CGRectMake((self.view.frame.width - size) / 2, size, size, size))
        actionButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        actionButton.addTarget(self, action: Selector("actionShowLoader"), forControlEvents: UIControlEvents.TouchUpInside)
        actionButton.setTitle("Show loader", forState: UIControlState.Normal)
        self.view.addSubview(actionButton)
    }
    
    func actionShowLoader() {
        
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 150
        SwiftLoader.setConfig(config)
        
        SwiftLoader.show(animated: true)
        
        delay(seconds: 3.0) { () -> () in
            SwiftLoader.show(title: "Loading...", animated: true)
        }
        delay(seconds: 6.0) { () -> () in
            SwiftLoader.hide()
        }
        
    }
    
    
}

