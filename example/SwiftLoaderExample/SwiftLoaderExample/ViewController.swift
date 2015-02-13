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
        
        self.view.backgroundColor = UIColor(red:0.98, green:0.93, blue:0.81, alpha:1)
        self.addButton()
    }
    
    func addButton() {
        let size : CGFloat = 200.0
        var actionButton = UIButton(frame: CGRectMake((self.view.frame.width - size) / 2, size, size, size))
        actionButton.setTitleColor(UIColor(red:0.52, green:0.07, blue:0.72, alpha:1), forState: UIControlState.Normal)
        actionButton.addTarget(self, action: Selector("actionShowLoader"), forControlEvents: UIControlEvents.TouchUpInside)
        actionButton.setTitle("Show loader", forState: UIControlState.Normal)
        self.view.addSubview(actionButton)
    }
    
    func actionShowLoader() {
        
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 170
        config.backgroundColor = UIColor(red:0.03, green:0.82, blue:0.7, alpha:1)
        config.spinnerColor = UIColor(red:0.88, green:0.26, blue:0.18, alpha:1)
        config.titleTextColor = UIColor(red:0.88, green:0.26, blue:0.18, alpha:1)
        config.spinnerLineWidth = 2.0
        
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

