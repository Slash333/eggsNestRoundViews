//
//  RoundViewBird.swift
//  TSDragAndDrop
//
//  Created by Igor Ponomarenko on 6/15/15.
//  Copyright (c) 2015 Igor Ponomarenko. All rights reserved.
//

import UIKit

class RoundViewEgg: RoundView {
    
    var nest: RoundViewNest?
    var location: CGPoint?
    var initialLocation: CGPoint?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialLocation = center
        
        initGestureRecognizer()
    }
    
    func initGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        addGestureRecognizer(panGestureRecognizer)
    }
    
    func goBack() {
        if let initialLocation = initialLocation {
            UIView.animateWithDuration(0.7) {
                self.center = initialLocation
            }
        }
    }
    
    func handlePanGesture(gestureRecognizer: UIGestureRecognizer) {
        let panGestureRecognizer = gestureRecognizer as! UIPanGestureRecognizer
        let state = panGestureRecognizer.state
        
        switch(state) {
            
        case .Changed:
            location = panGestureRecognizer.locationInView(superview!)
            NSNotificationCenter.defaultCenter().postNotificationName(kCenterPositionChanged, object: self)
            
            var nestFound = false
            
            if let superview = superview {
                for view in superview.subviews {
                    if let roundViewNest = view as? RoundViewNest {
                        if CGRectIntersectsRect(roundViewNest.frame, frame) {
                            
                            if nest != roundViewNest {
                                handleNestLosed()
                            }
                            
                            nest = roundViewNest
                            
                            NSNotificationCenter.defaultCenter().postNotificationName(kGotNest, object: self)
                            
                            nestFound = true
                        }
                    }
                }
            }
            
            if nestFound == false {
                handleNestLosed()
            }
            
        case .Ended:
            handlePanEnded()
            
        case .Failed:
            handlePanEnded()
            
        case .Cancelled:
            handlePanEnded()
            
        default:
            break
            
        }
        
        //panGestureRecognizer.setTranslation(CGPointZero, inView: self)
    }
    
    func handlePanEnded() {
        changeSelectedState(sSelected: false)
        NSNotificationCenter.defaultCenter().postNotificationName(kPanGestureEnded, object: self)
    }
    
    func handleNestLosed() {
        if nest != nil {
            NSNotificationCenter.defaultCenter().postNotificationName(kNestDidLose, object: self)
            nest = nil
        }
    }
    
    // MARK - overrides touches functions
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        changeSelectedState(sSelected: true)
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        changeSelectedState(sSelected: false)
    }
}