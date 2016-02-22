//
//  KOActivityIndicator.swift
//  KOActivityIndicator
//
//  Created by okohtenko on 11/03/15.
//  Copyright (c) 2015 kohtenko. All rights reserved.
//

import UIKit

public enum KOActivityIndicatorStyle: Int{
    case NoSpin
    case SpinInEnd
    case SpinInMove
    
}

@IBDesignable
public class KOActivityIndicator: UIView {
    
    @IBInspectable public var dotsColor: UIColor = UIColor.blackColor(){
        didSet{
            for dot in dots{
                dot.backgroundColor = dotsColor.CGColor
            }
        }
    }
    
    @IBInspectable public var animated: Bool = false{
        didSet{
            if animated {
                startAnimating()
            }else{
                stopAnimating()
            }
        }
    }
    
    @IBInspectable public var hideOnStop: Bool = true
    
    @IBInspectable public var style: KOActivityIndicatorStyle = .NoSpin {
        didSet{
            stopAnimating()
            startAnimating()
        }
    }
    
    private var dots: [CALayer] = []
    
    private var localCenter: CGPoint{
        return CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetMidY(bounds))
    }
    
    private let dotSide: CGFloat = 10
    
    private let dotSmallestDistance: CGFloat = 0
    private let dotLargestDistance: CGFloat = 10
    
    /**
    Start animation from begining
    Ignored if already animated
    */
    public func startAnimating(){
        if dots.first?.animationForKey("moveAnimation") != nil {
            return
        }
        if hideOnStop {
            self.hidden = false
        }
        createLayersIfNeeded()
        setupInitialPlaces()
        var dotsDelay = 0.1
        switch style{
        case .NoSpin:
            dotsDelay = 0
        case .SpinInMove, .SpinInEnd:
            dotsDelay = 0.1
            
        }
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(dotsDelay * Double(NSEC_PER_SEC)))
        self.startLayerAnimation(self.dots[0], toPosition: CGPoint(x: self.localCenter.x, y: self.localCenter.y - self.dotSide - self.dotLargestDistance))
        dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
            self.startLayerAnimation(self.dots[2], toPosition: CGPoint(x: self.localCenter.x + self.dotSide + self.dotLargestDistance, y: self.localCenter.y))
            dispatch_after(time, dispatch_get_main_queue()){ () -> Void in
                self.startLayerAnimation(self.dots[3], toPosition: CGPoint(x: self.localCenter.x, y: self.localCenter.y + self.dotSide + self.dotLargestDistance))
                dispatch_after(time, dispatch_get_main_queue()){ () -> Void in
                    self.startLayerAnimation(self.dots[1], toPosition: CGPoint(x: self.localCenter.x - self.dotSide - self.dotLargestDistance, y: self.localCenter.y))
                }
            }
        }
    }
    
    /**
    Stop animation
    */
    public func stopAnimating(){
        for dot in dots{
            dot.removeAllAnimations()
        }
        if hideOnStop {
            self.hidden = true
        }
    }
    
    private func createLayersIfNeeded(){
        if dots.count == 0{
            for _ in 1...4{
                let layer = CALayer()
                layer.backgroundColor = dotsColor.CGColor
                layer.bounds = CGRect(x: 0, y: 0, width: dotSide, height: dotSide)
                self.layer.addSublayer(layer)
                dots.append(layer)
            }
        }
    }
    
    private func setupInitialPlaces(){
        for dot in dots{
            dot.transform = CATransform3DMakeRotation(CGFloat(M_PI_4), 0, 0, 1.0)
        }
        dots[0].position = CGPoint(x: localCenter.x, y: localCenter.y - dotSide - dotSmallestDistance)
        dots[1].position = CGPoint(x: localCenter.x - dotSide - dotSmallestDistance, y: localCenter.y)
        dots[2].position = CGPoint(x: localCenter.x + dotSide + dotSmallestDistance, y: localCenter.y)
        dots[3].position = CGPoint(x: localCenter.x, y: localCenter.y + dotSide + dotSmallestDistance)
    }
    
    private func startLayerAnimation(layer: CALayer, toPosition position: CGPoint){
        let animation1 = CAKeyframeAnimation(keyPath: "position")
        animation1.values = positionValuesFromValue(layer.position, toValue: position)
        animation1.keyTimes = positionKeyTimes
        animation1.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let animation2 = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        animation2.cumulative = true
        animation2.values = rotationValues
        animation2.keyTimes = rotationKeyTimes
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = dotTripDuration
        animationGroup.repeatCount = Float(Int.max)
        animationGroup.animations = [animation1, animation2]
        
        layer.addAnimation(animationGroup, forKey: "moveAnimation")
    }
    
    private var dotTripDuration: CFTimeInterval {
        get{
            switch style{
            case .SpinInEnd:
                return 1
            case .SpinInMove:
                return 1
            case .NoSpin:
                return 1
            }
        }
    }
    
    private func positionValuesFromValue(position1:CGPoint, toValue position2:CGPoint) -> [AnyObject] {
        switch style{
        case .SpinInEnd, .SpinInMove:
            return [
                NSValue(CGPoint: position1),
                NSValue(CGPoint: position2),
                NSValue(CGPoint: position2),
                NSValue(CGPoint: position1),
                NSValue(CGPoint: position1)]
        case .NoSpin:
            return [
                NSValue(CGPoint: position1),
                NSValue(CGPoint: position2),
                NSValue(CGPoint: position1)]
        }
    }
    
    private var positionKeyTimes: [NSNumber] {
        get{
            switch style{
            case .SpinInEnd:
                return [0, 0.2, 0.5, 0.7, 1]
            case .SpinInMove:
                return [0, 0.2, 0.5, 0.7, 1]
            case .NoSpin:
                return [0, 0.5, 1]
            }
        }
    }
    
    private var rotationKeyTimes: [NSNumber] {
        get{
            switch style{
            case .SpinInEnd:
                return [0.0, 0.3, 0.5, 0.5, 1]
            case .SpinInMove:
                return [0.0, 0.25, 0.5, 1]
            case .NoSpin:
                return []
            }
        }
    }
    
    private var rotationValues: [AnyObject] {
        get{
            switch style{
            case .SpinInEnd:
                return [M_PI_4, M_PI_4, 5 * M_PI_4, M_PI_4, M_PI_4]
            case .SpinInMove:
                return [M_PI_4, 5 * M_PI_4 , 2 * M_PI + M_PI_4, 2 * M_PI + M_PI_4]
            case .NoSpin:
                return []
            }
        }
    }
    
}