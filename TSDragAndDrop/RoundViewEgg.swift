//
//  RoundViewBird.swift
//  TSDragAndDrop
//
//  Created by Igor Ponomarenko on 6/15/15.
//  Copyright (c) 2015 Igor Ponomarenko. All rights reserved.
//

import UIKit

class RoundViewEgg: RoundView {
    
    var isNew = true
    var nest: RoundViewNest?
    var location: CGPoint?
    var initialLocation: CGPoint?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initGestureRecognizer()
    }
    
    func goBack() {
        if let initialLocation = initialLocation {
            UIView.animateWithDuration(0.7) {
                self.center = initialLocation
            }
        }
    }
    
    func initGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        addGestureRecognizer(panGestureRecognizer)
    }
    
    func handlePanGesture(gestureRecognizer: UIGestureRecognizer) {
        let panGestureRecognizer = gestureRecognizer as! UIPanGestureRecognizer
        let state = panGestureRecognizer.state
        
        switch(state) {
            
        case .Began:
            initialLocation = center
            
        case .Changed:
            location = panGestureRecognizer.locationInView(superview!)
            NSNotificationCenter.defaultCenter().postNotificationName(Notifications.CenterPositionChanged.rawValue, object: self)
            
            var nestFound = false
            
            if let superview = superview {
                for view in superview.subviews {
                    if let roundViewNest = view as? RoundViewNest {
                        if CGRectIntersectsRect(roundViewNest.frame, frame) {
                            
                            if nest != roundViewNest {
                                loseNest()
                            }
                            
                            nest = roundViewNest
                            
                            NSNotificationCenter.defaultCenter().postNotificationName(Notifications.GotNest.rawValue, object: self)
                            
                            nestFound = true
                            isNew = false
                        }
                    }
                }
            }
            
            if nestFound == false {
                loseNest()
            }
            
            
        case .Ended:
            panEnded()
            
        case .Failed:
            panEnded()
            
        case .Cancelled:
            panEnded()
            
        default:
            break
            
        }
        
        //panGestureRecognizer.setTranslation(CGPointZero, inView: self)
    }
    
    func panEnded() {
        changeSelectedState(sSelected: false)
        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.PanGestureEnded.rawValue, object: self)
    }
    
    func loseNest() {
        if nest != nil {
            NSNotificationCenter.defaultCenter().postNotificationName(Notifications.LoseNest.rawValue, object: self)
            nest = nil
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        changeSelectedState(sSelected: true)
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        changeSelectedState(sSelected: false)
    }
}