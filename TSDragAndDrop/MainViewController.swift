//
//  MainViewController.swift
//  TSDragAndDrop
//
//  Created by Igor Ponomarenko on 6/17/15.
//  Copyright (c) 2015 Igor Ponomarenko. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, OBOvumSource, OBDropZone/*, DNDDragSourceDelegate, DNDDropTargetDelegate*/ {

    @IBOutlet var dragAndDropController: DNDDragAndDropController!
    
    var leftViewController: ViewController?
    var eggTableViewController: EggTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let dragRecognizer = DNDLongPressDragRecognizer()
        //dragRecognizer.minimumPressDuration = 0.1
        
        //eggTableViewController?.tableView.panGestureRecognizer.requireGestureRecognizerToFail(dragRecognizer)
        
        //dragAndDropController.registerDragSource(eggTableViewController?.tableView, withDelegate: self, dragRecognizer: dragRecognizer)
        //dragAndDropController.registerDropTarget(eggTableViewController?.tableView, withDelegate: self)
        
        var ddManager = OBDragDropManager.sharedManager()
        
        var gesture = ddManager.createLongPressDragDropGestureRecognizerWithSource(self)
        eggTableViewController?.tableView.addGestureRecognizer(gesture)
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
        ovum.dataObject = NSNumber(integer: sourceView.tag)
        return ovum
    }
    
    func createDragRepresentationOfSourceView(sourceView: UIView!, inWindow window: UIWindow!) -> UIView! {
        var draggingView = NSBundle.mainBundle().loadNibNamed("GhostEgg", owner: nil, options: nil).first as! GhostEgg
        view.addSubview(draggingView)
        
        draggingView.center = sourceView.center
        return draggingView
    }
    
    
    
    // MARK: OBDropZone
    
    func ovumDropped(ovum: OBOvum!, inView view: UIView!, atLocation location: CGPoint) {
        NSLog("ovumDropped");
    }
    
    func ovumEntered(ovum: OBOvum!, inView view: UIView!, atLocation location: CGPoint) -> OBDropAction {
        NSLog("ovumEntered");
        
        return OBDropAction.Move
    }
    
    func ovumExited(ovum: OBOvum!, inView view: UIView!, atLocation location: CGPoint) {
        NSLog("ovumExited");
    }
    
    /*
    // MARK: DNDDragSourceDelegate
    
    func draggingViewForDragOperation(operation: DNDDragOperation!) -> UIView! {
        var draggingView = NSBundle.mainBundle().loadNibNamed("GhostEgg", owner: nil, options: nil).first as! GhostEgg
        view.addSubview(draggingView)
        draggingView.alpha = 0
        
        UIView.animateWithDuration(0.5) {
            draggingView.alpha = 1
        }
        
        return draggingView
    }
    
    func dragOperationWillCancel(operation: DNDDragOperation!) {
        operation.removeDraggingViewAnimatedWithDuration(0.5, animations: { (draggingView: UIView!) -> Void in
            draggingView.alpha = 0
            draggingView.center = self.view.convertPoint(operation.dragSourceView.center, fromView: operation.dragSourceView)
            //operation.removeDraggingView()
        })
        
        
    }
    
    // MARK: DNDDropTargetDelegate
    
    func dragOperation(operation: DNDDragOperation!, didDropInDropTarget target: UIView!) {
        var view = target;
        var x = 1
        x = 3
        
        operation.removeDraggingView()
    }
    
    func dragOperation(operation: DNDDragOperation!, didEnterDropTarget target: UIView!) {
        var view = target;
        var x = 1
        x = 3
    }
    
    func dragOperation(operation: DNDDragOperation!, shouldPositionDragViewInDropTarget target: UIView!) -> Bool {
        return true
    }
*/
    
}
