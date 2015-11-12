//
//  SwiftLoader.swift
//  SwiftLoader
//
//  Created by Kirill Kunst on 07.02.15.
//  Copyright (c) 2015 Kirill Kunst. All rights reserved.
//

import UIKit
import QuartzCore
import CoreGraphics

let loaderSpinnerMarginSide : CGFloat = 35.0
let loaderSpinnerMarginTop  : CGFloat = 20.0
let loaderTitleMargin       : CGFloat = 5.0

public class SwiftLoader: UIView {
    
    /*
     * MARK: - Private variables
     */
    
    private var coverView   : UIView?
    private var titleLabel  : UILabel?
    private var loadingView : SwiftLoadingView?
    private var animated    : Bool = true
    private var canUpdated  : Bool = false
    private var title       : String?
    private var speed       : Int = 1
    
    private var config = SwiftLoaderConfig() {
        didSet {
            self.loadingView?.config = config
        }
    }
    
    /*
     * MARK: - Public variables
     */
    
    override public var frame : CGRect {
        didSet {
            self.update()
        }
    }
    
    class var sharedInstance: SwiftLoader {
        struct Singleton {
            static let instance = SwiftLoader(frame: CGRectMake(0, 0, SwiftLoaderConfig().size, SwiftLoaderConfig().size))
        }
        return Singleton.instance
    }
    
    /*
     * MARK: - Constructor
     */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /*
     * MARK: - Public methods
     */
    
    public class func show(animated animated: Bool) {
        self.show(animated: animated, title: nil, topMargin: 0)
    }
    
    public class func show(animated animated: Bool, title: String?) {
        self.show(animated: animated, title: title, topMargin: 0)
    }
    
    public class func show(animated animated: Bool, topMargin: Int) {
        self.show(animated: animated, title: nil, topMargin: topMargin)
    }
    
    public class func show(animated animated: Bool, title: String?, topMargin: Int) {
        let currentWindow : UIWindow = UIApplication.sharedApplication().keyWindow!
        
        let loader = SwiftLoader.sharedInstance
        loader.canUpdated = true
        loader.animated = animated
        loader.title = title
        loader.update()
        
        let height : CGFloat = UIScreen.mainScreen().bounds.size.height
        let width  : CGFloat = UIScreen.mainScreen().bounds.size.width
        let center : CGPoint = CGPointMake(width / 2.0, height / 2.0 - CGFloat(topMargin))
        loader.center = center
        
        if loader.superview == nil {
            loader.coverView = UIView(frame: currentWindow.bounds)
            loader.coverView?.backgroundColor = loader.config.foregroundColor.colorWithAlphaComponent(loader.config.foregroundAlpha)
            
            currentWindow.addSubview(loader.coverView!)
            currentWindow.addSubview(loader)
            loader.start()
        }
    }
    
    public class func hide() {
        let loader = SwiftLoader.sharedInstance
        loader.stop()
    }
    
    public class func setConfig(config : SwiftLoaderConfig) {
        let loader = SwiftLoader.sharedInstance
        loader.config = config
        loader.frame = CGRectMake(0, 0, loader.config.size, loader.config.size)
    }
    
    /*
     * MARK: - Private methods
     */
    
    private func start() {
        self.loadingView?.start()
        
        if self.animated {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.alpha = 1
                }, completion: { (finished) -> Void in
                    
            });
        } else {
            self.alpha = 1
        }
    }
    
    private func stop() {
        if self.animated {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.alpha = 0
                }, completion: { (finished) -> Void in
                    self.removeFromSuperview()
                    self.coverView?.removeFromSuperview()
                    self.loadingView?.stop()
            });
        } else {
            self.alpha = 0
            self.removeFromSuperview()
            self.coverView?.removeFromSuperview()
            self.loadingView?.stop()
        }
    }
    
    private func setup() {
        self.alpha = 0
        self.update()
    }
    
    private func update() {
        self.backgroundColor = self.config.backgroundColor
        self.layer.cornerRadius = self.config.cornerRadius
        let loadingViewSize = self.frame.size.width - (loaderSpinnerMarginSide * 2)
        
        if self.loadingView == nil {
            self.loadingView = SwiftLoadingView(frame: self.frameForSpinner())
            self.addSubview(self.loadingView!)
        } else {
            self.loadingView?.frame = self.frameForSpinner()
        }
        
        if self.titleLabel == nil {
            self.titleLabel = UILabel(frame: CGRectMake(loaderTitleMargin, loaderSpinnerMarginTop + loadingViewSize, self.frame.width - loaderTitleMargin*2, 42.0))
            self.addSubview(self.titleLabel!)
            self.titleLabel?.numberOfLines = 1
            self.titleLabel?.textAlignment = NSTextAlignment.Center
            self.titleLabel?.adjustsFontSizeToFitWidth = true
        } else {
            self.titleLabel?.frame = CGRectMake(loaderTitleMargin, loaderSpinnerMarginTop + loadingViewSize, self.frame.width - loaderTitleMargin*2, 42.0)
        }
        
        self.titleLabel?.font = self.config.titleTextFont
        self.titleLabel?.textColor = self.config.titleTextColor
        self.titleLabel?.text = self.title
        
        self.titleLabel?.hidden = self.title == nil
    }
    
    private func frameForSpinner() -> CGRect {
        let loadingViewSize = self.frame.size.width - (loaderSpinnerMarginSide * 2)
        
        if self.title == nil {
            let yOffset = (self.frame.size.height - loadingViewSize) / 2
            return CGRectMake(loaderSpinnerMarginSide, yOffset, loadingViewSize, loadingViewSize)
        } else {
            return CGRectMake(loaderSpinnerMarginSide, loaderSpinnerMarginTop, loadingViewSize, loadingViewSize)
        }
    }
    
}
