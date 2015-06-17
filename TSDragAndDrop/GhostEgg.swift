//
//  GhostEgg.swift
//  TSDragAndDrop
//
//  Created by Igor Ponomarenko on 6/16/15.
//  Copyright (c) 2015 Igor Ponomarenko. All rights reserved.
//

import UIKit

class GhostEgg: RoundView, UIGestureRecognizerDelegate {
    
    var nest: RoundViewNest?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        //panGestureRecognizer.delegate = self
        //addGestureRecognizer(panGestureRecognizer)
    }
    /*
    func handlePanGesture(panGestureRecognizer: UIPanGestureRecognizer) {
        switch(panGestureRecognizer.state) {
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
    
    // MARK - .. functions
    
    func goBack() { // refactoring 
        if let initialLocation = initialLocation {
            UIView.animateWithDuration(0.7) {
                self.center = initialLocation
            }
        }
    }
    */
}