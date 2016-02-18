//
//  SwiftLoadingView.swift
//  SwiftLoader
//
//  Created by Kirill Kunst on 2015-11-09.
//  Copyright (c) 2015 Kirill Kunst. All rights reserved.
//

import UIKit

class SwiftLoadingView : UIView {
    
    /*
     * MARK: - Private variables
     */
    
    private var speed           : Int?
    private var lineWidth       : Float?
    private var lineTintColor   : UIColor?
    private var backgroundLayer : CAShapeLayer?
    private var isSpinning      : Bool?
    
    /*
     * MARK: - Public variable
     */
    
    internal var config = SwiftLoaderConfig() {
        didSet {
            self.update()
        }
    }
    
    /*
     * MARK: - Constructor
     */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /*
     * MARK: - Public methods
     */
    
    internal func start() {
        self.isSpinning? = true
        self.drawBackgroundCircle(true)
        
        let rotationAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(double: M_PI * 2.0)
        rotationAnimation.duration = CFTimeInterval(speed!);
        rotationAnimation.cumulative = true;
        rotationAnimation.repeatCount = HUGE;
        self.backgroundLayer?.addAnimation(rotationAnimation, forKey: "rotationAnimation")
    }
    
    internal func stop() {
        self.drawBackgroundCircle(false)
        
        self.backgroundLayer?.removeAllAnimations()
        self.isSpinning? = false
    }
    
    /*
     * MARK: - Private methods
     */
    
    private func setup() {
        self.backgroundColor = UIColor.clearColor()
        self.lineWidth = fmaxf(Float(self.frame.size.width) * 0.025, 1)
        
        self.backgroundLayer = CAShapeLayer()
        self.backgroundLayer?.strokeColor = self.config.spinnerColor.CGColor
        self.backgroundLayer?.fillColor = self.backgroundColor?.CGColor
        self.backgroundLayer?.lineCap = kCALineCapRound
        self.backgroundLayer?.lineWidth = CGFloat(self.lineWidth!)
        self.layer.addSublayer(self.backgroundLayer!)
    }
    
    private func update() {
        self.lineWidth = self.config.spinnerLineWidth
        self.speed = self.config.speed
        
        self.backgroundLayer?.lineWidth = CGFloat(self.lineWidth!)
        self.backgroundLayer?.strokeColor = self.config.spinnerColor.CGColor
    }
    
    /*
     * MARK: Draw Circle
     */
    
    override func drawRect(rect: CGRect) {
        self.backgroundLayer?.frame = self.bounds
    }
    
    private func drawBackgroundCircle(partial : Bool) {
        let startAngle : CGFloat = CGFloat(M_PI) / CGFloat(2.0)
        var endAngle   : CGFloat = (2.0 * CGFloat(M_PI)) + startAngle
        
        let center : CGPoint = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)
        let radius : CGFloat = (CGFloat(self.bounds.size.width) - CGFloat(self.lineWidth!)) / CGFloat(2.0)
        
        let processBackgroundPath : UIBezierPath = UIBezierPath()
        processBackgroundPath.lineWidth = CGFloat(self.lineWidth!)
        
        if partial {
            endAngle = (1.8 * CGFloat(M_PI)) + startAngle
        }
        
        processBackgroundPath.addArcWithCenter(center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        self.backgroundLayer?.path = processBackgroundPath.CGPath;
    }
    
}
