//
//  RoundViewBird.swift
//  TSDragAndDrop
//
//  Created by Igor Ponomarenko on 6/15/15.
//  Copyright (c) 2015 Igor Ponomarenko. All rights reserved.
//

import UIKit

class RoundViewEgg: RoundView, UIGestureRecognizerDelegate {
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    var nest: RoundViewNest? // refactoring
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialLocation = center
        initGestureRecognizer()
        
        var longPress = UILongPressGestureRecognizer(target: self, action: "handleLongPressGesture:")
        longPress.delegate = self
        
        
        addGestureRecognizer(longPress)
    }
    
    // MARK - gestures
    
    func initGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        addGestureRecognizer(panGestureRecognizer)
    }
    
    
    func handleLongPressGesture(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        switch(longPressGestureRecognizer.state) {
        case .Began:
            var ghostEgg = NSBundle.mainBundle().loadNibNamed("GhostEgg", owner: nil, options: nil).first as! GhostEgg
            self.userInteractionEnabled = false
            self.alpha = 0.0
            
            ghostEgg.center = center
            ghostEgg.alpha = 0.5
            
            longPressGestureRecognizer.enabled = false
            superview?.insertSubview(ghostEgg, belowSubview: self)
            
            
            //userInteractionEnabled = false
        //case .Ended:
            //userInteractionEnabled = true
            
        default:
            break
        }
    }
    
    
    
    func handlePanGesture(panGestureRecognizer: UIPanGestureRecognizer) {
        /*switch(panGestureRecognizer.state) {
        //case .Began:
          //  handleBeginDragging()
        case .Changed:
            location = panGestureRecognizer.locationInView(superview!)
            NSNotificationCenter.defaultCenter().postNotificationName(kCenterPositionChanged, object: self)
            
            var nestFound = false
            
            if let superview = superview {
                for view in superview.subviews {
                    if let roundViewNest = view as? RoundViewNest {
                        if CGRectIntersectsRect(roundViewNest.frame, frame) {
                            
                            // more accurate
                            // check are circles inside frames intersect?
                            if circlesInsideFramesIntersects(roundViewNest.frame, frame) {
                                handleGotNest(roundViewNest)
                                nestFound = true
                            }
                            
                        }
                    }
                }
            }
            
            if nestFound == false {
                handleNestLosed()
            }
            
        case .Ended, .Failed, .Cancelled:
            handlePanEnded()
        
        default:
            break
            
        }
*/
    }
    
    // MARK - .. functions
    
    func goBack() { // refactoring
        if let initialLocation = initialLocation {
            UIView.animateWithDuration(0.7) {
                self.center = initialLocation
            }
        }
    }
    
    // MARK - event handlers
    
    func handleBeginDragging() {
        NSNotificationCenter.defaultCenter().postNotificationName(kBeginDragging, object: self)
    }
    
    func handlePanEnded() {
        changeSelectedState(sSelected: false)
        NSNotificationCenter.defaultCenter().postNotificationName(kPanGestureEnded, object: self)
    }
    
    func handleGotNest(let roundViewNest: RoundViewNest) {
        if nest != roundViewNest {
            handleNestLosed()
        }
        
        nest = roundViewNest
        
        NSNotificationCenter.defaultCenter().postNotificationName(kGotNest, object: self)
    }
    
    func handleNestLosed() {
        if nest != nil {
            NSNotificationCenter.defaultCenter().postNotificationName(kNestDidLose, object: self)
            nest = nil
        }
    }
    
    // MARK - overrides touches functions
    
    /*override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        handleBeginDragging()
        
        changeSelectedState(sSelected: true)
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        changeSelectedState(sSelected: false)
    }*/
}