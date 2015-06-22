//
//  RoundViewThrash.swift
//  TSDragAndDrop
//
//  Created by Igor Ponomarenko on 6/22/15.
//  Copyright (c) 2015 Igor Ponomarenko. All rights reserved.
//

import Foundation

let kLazyTimeIntervalForShowAction = NSTimeInterval(0.7) // seconds
let kLazyTimeIntervalForHideAction = NSTimeInterval(1.5) // seconds

class RoundViewTrash: RoundView {
    
    var showTimer: NSTimer?
    var hideTimer: NSTimer?
    
    func lazyShowWithAnimation() {
        stopHideTimer()
        
        if hidden == false {
            return
        }
        
        startShowTimer()
    }
    
    func lazyHideWithAnimation() {
        stopShowTimer()
        
        if hidden == true {
            return
        }
        
        startHideTimer()
    }
    
    // MARK: start timers
    private func startShowTimer() {
        stopShowTimer()
        
        showTimer = NSTimer.scheduledTimerWithTimeInterval(kLazyTimeIntervalForShowAction,
            target: self,
            selector: "showWithAnimation",
            userInfo: nil,
            repeats: false)
    }
    
    private func startHideTimer() {
        stopTimer(&hideTimer)
        
        hideTimer = NSTimer.scheduledTimerWithTimeInterval(kLazyTimeIntervalForHideAction,
            target: self,
            selector: "hideWithAnimation",
            userInfo: nil,
            repeats: false)
    }
    
    // MARK: stop timers
    
    private func stopTimer(inout aTimer: NSTimer?) {
        if let timer = aTimer {
            if timer.valid {
                timer.invalidate()
            }
            
            aTimer = nil
        }
    }
    
    private func stopShowTimer() {
        stopTimer(&showTimer)
    }
    
    private func stopHideTimer() {
        stopTimer(&hideTimer)
    }
    
    // MARK: timer functions
    
    func showWithAnimation() {
        stopShowTimer()
        
        if hidden == false {
            return
        }
        
        alpha = 0
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.alpha = 1
            self.hidden = false
        })
    }
    
    func hideWithAnimation() {
        stopHideTimer()
        
        if hidden == true {
            return
        }
        
        var animation = CATransition()
        animation.type = kCATransitionFade
        animation.duration = 0.5
        layer.addAnimation(animation, forKey: nil)
        
        hidden = true
    }
}