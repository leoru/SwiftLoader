//
//  SwiftLoaderConfig.swift
//  SwiftLoader
//
//  Created by Kirill Kunst on 2015-11-09.
//  Copyright (c) 2015 Kirill Kunst. All rights reserved.
//

import UIKit

public class SwiftLoaderConfig {
    
    public init() {}
    
    /**
     *  Size of loader
     */
    public var size : CGFloat = 120.0
    
    /**
     *  Color of spinner view
     */
    public var spinnerColor = UIColor.blackColor()
    
    /**
     *  Spinner Line Width
     */
    public var spinnerLineWidth : Float = 1.0
    
    /**
     *  Color of title text
     */
    public var titleTextColor = UIColor.blackColor()
    
    /**
     *  Speed of the spinner
     */
    public var speed : Int = 1
    
    /**
     *  Font for title text in loader
     */
    public var titleTextFont : UIFont = UIFont.boldSystemFontOfSize(16.0)
    
    /**
     *  Background color for loader
     */
    public var backgroundColor = UIColor.whiteColor()
    
    /**
     *  Foreground color
     */
    public var foregroundColor = UIColor.clearColor()
    
    /**
     *  Foreground alpha CGFloat, between 0.0 and 1.0
     */
    public var foregroundAlpha : CGFloat = 0.0
    
    /**
     *  Corner radius for loader
     */
    public var cornerRadius : CGFloat = 10.0

}
