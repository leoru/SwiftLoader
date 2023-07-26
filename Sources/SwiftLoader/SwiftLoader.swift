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

public class SwiftLoader: UIView {
    
    struct Constants {
        static let loaderSpinnerMarginSide : CGFloat = 35.0
        static let loaderSpinnerMarginTop : CGFloat = 20.0
        static let loaderTitleMargin : CGFloat = 5.0
    }
    
    private var coverView : UIView?
    private var titleLabel : UILabel?
    private var loadingView : SwiftLoadingView?
    private var animated : Bool = true
    private var canUpdated = false
    private var title: String?
    private var speed = 1
    
    private var config : Config = Config() {
        didSet {
            self.loadingView?.config = config
        }
    }
    
    override public var frame : CGRect {
        didSet {
            self.update()
        }
    }
    
    class var shared: SwiftLoader {
        struct Singleton {
            static let instance = SwiftLoader(frame: CGRect(origin: CGPoint(x: 0,y: 0),size: CGSize(width: Config().size,height: Config().size)))
        }
        return Singleton.instance
    }
    
    public class func show(animated: Bool) {
        self.show(title: nil, animated: animated)
    }
    
    public class func show(title: String?, animated : Bool) {
        let currentWindow: UIWindow? = UIApplication
            .shared
            .connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
        
        guard let currentWindow = currentWindow else { return }
        
        let loader = SwiftLoader.shared
        loader.canUpdated = true
        loader.animated = animated
        loader.title = title
        loader.update()
        
        NotificationCenter.default.addObserver(loader, selector: #selector(loader.rotated(notification: )),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
        
        let height: CGFloat = UIScreen.main.bounds.size.height
        let width: CGFloat = UIScreen.main.bounds.size.width
        let center: CGPoint = CGPoint(x: width / 2.0, y: height / 2.0)
        
        loader.center = center
        
        if (loader.superview == nil) {
            loader.coverView = UIView(frame: currentWindow.bounds)
            loader.coverView?.backgroundColor = loader.config.foregroundColor.withAlphaComponent(loader.config.foregroundAlpha)
            
            currentWindow.addSubview(loader.coverView!)
            currentWindow.addSubview(loader)
            loader.start()
        }
    }
    
    public class func hide() {
        NotificationCenter.default.removeObserver(SwiftLoader.shared)
        SwiftLoader.shared.stop()
    }
    
    public class func setConfig(_ config: Config) {
        let loader = SwiftLoader.shared
        loader.config = config
        loader.frame = CGRect(origin: CGPoint(x: 0, y: 0),
                              size: CGSize(width: loader.config.size,
                                           height: loader.config.size))
    }
    
    @objc func rotated(notification: NSNotification) {
        let loader = SwiftLoader.shared
        
        let height: CGFloat = UIScreen.main.bounds.size.height
        let width: CGFloat = UIScreen.main.bounds.size.width
        let center: CGPoint = CGPoint(x: width / 2.0, y: height / 2.0)
        
        loader.center = center
        loader.coverView?.frame = UIScreen.main.bounds
    }
    
    // MARK: - Private methods
    
    private func setup() {
        self.alpha = 0
        self.update()
    }
    
    private func start() {
        self.loadingView?.start()
        
        if (self.animated) {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.alpha = 1
            }, completion: { (finished) -> Void in
                
            });
        } else {
            self.alpha = 1
        }
    }
    
    private func stop() {
        if (self.animated) {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
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
    
    private func update() {
        self.backgroundColor = self.config.backgroundColor
        self.layer.cornerRadius = self.config.cornerRadius
        let loadingViewSize = self.frame.size.width - (Constants.loaderSpinnerMarginSide * 2)
        
        if (self.loadingView == nil) {
            self.loadingView = SwiftLoadingView(frame: spinnerFrame)
            self.addSubview(self.loadingView!)
        } else {
            self.loadingView?.frame = spinnerFrame
        }
        
        if (self.titleLabel == nil) {
            self.titleLabel = UILabel(frame: CGRect(origin: CGPoint(x: Constants.loaderTitleMargin, y: Constants.loaderSpinnerMarginTop + loadingViewSize), size: CGSize(width: self.frame.width - Constants.loaderTitleMargin*2, height:  42.0)))
            self.addSubview(self.titleLabel!)
            self.titleLabel?.numberOfLines = 1
            self.titleLabel?.textAlignment = NSTextAlignment.center
            self.titleLabel?.adjustsFontSizeToFitWidth = true
        } else {
            self.titleLabel?.frame = CGRect(origin: CGPoint(x: Constants.loaderTitleMargin, y: Constants.loaderSpinnerMarginTop + loadingViewSize), size: CGSize(width: self.frame.width - Constants.loaderTitleMargin*2, height: 42.0))
        }
        
        self.titleLabel?.font = self.config.titleTextFont
        self.titleLabel?.textColor = self.config.titleTextColor
        self.titleLabel?.text = self.title
        self.titleLabel?.isHidden = self.title == nil
    }
    
    var spinnerFrame: CGRect {
        let loadingViewSize = self.frame.size.width - (Constants.loaderSpinnerMarginSide * 2)
        
        if (self.title == nil) {
            let yOffset = (self.frame.size.height - loadingViewSize) / 2
            return CGRect(origin: CGPoint(x: Constants.loaderSpinnerMarginSide, y: yOffset), size: CGSize(width: loadingViewSize, height: loadingViewSize))
        }
        return CGRect(origin: CGPoint(x: Constants.loaderSpinnerMarginSide, y: Constants.loaderSpinnerMarginTop), size: CGSize(width: loadingViewSize, height: loadingViewSize))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Loading View
    
    class SwiftLoadingView : UIView {
        
        private var speed : Int?
        private var lineWidth : Float?
        private var lineTintColor : UIColor?
        private var backgroundLayer : CAShapeLayer?
        private var isSpinning : Bool?
        
        var config : Config = Config() {
            didSet {
                self.update()
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.setup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        //MARK: Setup loading view
        
        func setup() {
            self.backgroundColor = UIColor.clear
            self.lineWidth = fmaxf(Float(self.frame.size.width) * 0.025, 1)
        
            self.backgroundLayer = CAShapeLayer()
            self.backgroundLayer?.strokeColor = self.config.spinnerColor.cgColor
            self.backgroundLayer?.fillColor = self.backgroundColor?.cgColor
            self.backgroundLayer?.lineCap = CAShapeLayerLineCap.round
            self.backgroundLayer?.lineWidth = CGFloat(self.lineWidth!)
            self.layer.addSublayer(self.backgroundLayer!)
        }
        
        func update() {
            self.lineWidth = self.config.spinnerLineWidth
            self.speed = self.config.speed
            
            self.backgroundLayer?.lineWidth = CGFloat(self.lineWidth!)
            self.backgroundLayer?.strokeColor = self.config.spinnerColor.cgColor
        }
        
        //MARK: Draw Circle
        
        override func draw(_ rect: CGRect) {
            self.backgroundLayer?.frame = self.bounds
        }
        
        func drawBackgroundCircle(partial: Bool) {
            let startAngle : CGFloat = CGFloat.pi / CGFloat(2.0)
            var endAngle : CGFloat = (2.0 * CGFloat.pi) + startAngle
            
            let center : CGPoint = CGPoint(x: self.bounds.size.width / 2,y: self.bounds.size.height / 2)
            let radius : CGFloat = (CGFloat(self.bounds.size.width) - CGFloat(self.lineWidth!)) / CGFloat(2.0)
            
            let processBackgroundPath : UIBezierPath = UIBezierPath()
            processBackgroundPath.lineWidth = CGFloat(self.lineWidth!)
            
            if (partial) {
                endAngle = (1.8 * CGFloat.pi) + startAngle
            }
            
            processBackgroundPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            self.backgroundLayer?.path = processBackgroundPath.cgPath;
        }
        
        // MARK: - Start and stop spinning
        
        func start() {
            self.isSpinning? = true
            self.drawBackgroundCircle(partial: true)
            
            let rotationAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotationAnimation.toValue = NSNumber(value: Double.pi * 2.0)
            rotationAnimation.duration = 1;
            rotationAnimation.isCumulative = true;
            rotationAnimation.repeatCount = HUGE;
            self.backgroundLayer?.add(rotationAnimation, forKey: "rotationAnimation")
        }
        
        func stop() {
            self.drawBackgroundCircle(partial: false)
            
            self.backgroundLayer?.removeAllAnimations()
            self.isSpinning? = false
        }
    }
    
    // MARK: - Loader config
    
    public struct Config {
        
        /// Size of loader
        public var size : CGFloat = 120.0
        
        /// Color of spinner view
        public var spinnerColor = UIColor.black
        
        /// Line width
        public var spinnerLineWidth :Float = 1.0
        
        /// Color of title text
        public var titleTextColor = UIColor.black
        
        /// Speed of the spinner
        public var speed :Int = 1
        
        /// Font for title text in loader
        public var titleTextFont : UIFont = UIFont.boldSystemFont(ofSize: 16.0)
        
        /// Background color for loader
        public var backgroundColor = UIColor.white
        
        /// Foreground color
        public var foregroundColor = UIColor.clear
        
        /// Foreground alpha CGFloat, between 0.0 and 1.0
        public var foregroundAlpha:CGFloat = 0.0
        
        /// Corner radius for loader
        public var cornerRadius : CGFloat = 10.0
        
        public init() {}
        
    }
}

