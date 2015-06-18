//
//  MainViewController.swift
//  TSDragAndDrop
//
//  Created by Igor Ponomarenko on 6/17/15.
//  Copyright (c) 2015 Igor Ponomarenko. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, OBOvumSource, OBDropZone {
    
    var leftViewController: ViewController?
    var eggTableViewController: EggTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // drop
        
        if let leftVC = leftViewController {
            for roundView in leftVC.roundViewArray {
                roundView.dropZoneHandler = self
            }
        }
        
        
        leftViewController?.view.dropZoneHandler = self
        eggTableViewController?.view.dropZoneHandler = self
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier == "leftView" {
            leftViewController = segue.destinationViewController as? ViewController
        } else if segue.identifier == "rightView" {
            eggTableViewController = segue.destinationViewController as? EggTableViewController
        }
    }
    
    // MARK: OBOvumSource
    
    func createOvumFromView(sourceView: UIView!) -> OBOvum! {
        var ovum = OBOvum()
        ovum.dataObject = sourceView
        return ovum
    }
    
    func createDragRepresentationOfSourceView(sourceView: UIView!, inWindow window: UIWindow!) -> UIView! {
        var draggingView = NSBundle.mainBundle().loadNibNamed("GhostEgg", owner: nil, options: nil).first as! GhostEgg
        view.addSubview(draggingView)
        
        if let egg = sourceView as? RoundViewEgg {
            var frame = egg.convertRect(egg.bounds, toView: egg.window)
                frame = window.convertRect(frame, fromWindow: egg.window)
                
                draggingView.frame = frame
        }
        
        return draggingView
    }
    
    // MARK: OBDropZone
    
    func ovumDropped(ovum: OBOvum!, inView view: UIView!, atLocation location: CGPoint) {
        
        if view == leftViewController?.view! ||
            view == eggTableViewController?.view! {
            
            if let nest = ovum.dataObject as? RoundViewNest{
                nest.backgroundColor = UIColor.redColor()
            
                for gesture in nest.gestureRecognizers as! [UIGestureRecognizer] {
                    nest.removeGestureRecognizer(gesture)
                }
            }
            
        } else if let nest = view as? RoundViewNest {
            nest.backgroundColor = UIColor.greenColor()
            
            var ddManager = OBDragDropManager.sharedManager()
            var gesture = ddManager.createDragDropGestureRecognizerWithClass(UIPanGestureRecognizer.self, source: self)
            nest.addGestureRecognizer(gesture)
        }
    }
    
    func ovumEntered(ovum: OBOvum!, inView view: UIView!, atLocation location: CGPoint) -> OBDropAction {
        
        if let nest = view as? RoundViewNest {
            nest.changeSelectedState(sSelected: true)
        }
        
        return OBDropAction.Move
    }
    
    func ovumMoved(ovum: OBOvum!, inView view: UIView!, atLocation location: CGPoint) -> OBDropAction {
        return OBDropAction.Move
    }
    
    func ovumExited(ovum: OBOvum!, inView view: UIView!, atLocation location: CGPoint) {
        if let nest = view as? RoundViewNest {
            nest.changeSelectedState(sSelected: false)
        }
    }
}
