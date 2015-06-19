//
//  MainViewController.swift
//  TSDragAndDrop
//
//  Created by Igor Ponomarenko on 6/17/15.
//  Copyright (c) 2015 Igor Ponomarenko. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, OBOvumSource, OBDropZone {
    
    private var _leftViewController: ViewController?
    private var _eggTableViewController: EggTableViewController?
    
    lazy var leftViewController: ViewController = {
        if self._leftViewController != nil {
            return self._leftViewController!
        }
        
        return ViewController()
    } ()
    
    lazy var eggTableViewController: EggTableViewController = {
        if self._eggTableViewController != nil {
            return self._eggTableViewController!
        }
        
        return EggTableViewController()
    } ()
    
    // MARK: overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // drop
        for roundView in leftViewController.roundViewArray {
            roundView.dropZoneHandler = self
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier == "leftView" {
            _leftViewController = segue.destinationViewController as? ViewController
        } else if segue.identifier == "rightView" {
            _eggTableViewController = segue.destinationViewController as? EggTableViewController
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
        } else if let nest = sourceView as? RoundViewNest {
            var center = window.convertPoint(nest.center, fromWindow: nest.window)
            draggingView.center = center
        }
        
        return draggingView
    }
    
    func dragViewWillAppear(dragView: UIView!, inWindow window: UIWindow!, atLocation location: CGPoint) {
        
        dragView.alpha = 0
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            dragView.alpha = 0.8
            dragView.transform = CGAffineTransformMakeScale(1.5, 1.5);
        }) { (completed: Bool) -> Void in
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                dragView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            })
        }
    }
    
    // MARK: OBDropZone
    
    func ovumDropped(ovum: OBOvum!, inView view: UIView!, atLocation location: CGPoint) {
        if let nest = view as? RoundViewNest {
            nest.backgroundColor = UIColor(red: 32.0/255.0, green: 255.0/255.0, blue: 142.0/255.0, alpha: 1)
            
            var ddManager = OBDragDropManager.sharedManager()
            
            // without long press
            var gesture = ddManager.createDragDropGestureRecognizerWithClass(UIPanGestureRecognizer.self, source: self)
            // long press
            //var gesture = ddManager.createLongPressDragDropGestureRecognizerWithSource(self)
            
            nest.addGestureRecognizer(gesture)
            
        } else if let nest = ovum.dataObject as? RoundViewNest{
            nest.backgroundColor = UIColor.redColor()
            
            for gesture in nest.gestureRecognizers as! [UIGestureRecognizer] {
                nest.removeGestureRecognizer(gesture)
            }
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
