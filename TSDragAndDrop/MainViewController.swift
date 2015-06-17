//
//  MainViewController.swift
//  TSDragAndDrop
//
//  Created by Igor Ponomarenko on 6/17/15.
//  Copyright (c) 2015 Igor Ponomarenko. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, DNDDragSourceDelegate/*, DNDDropTargetDelegate*/ {

    @IBOutlet var dragAndDropController: DNDDragAndDropController!
    
    var leftViewController: ViewController?
    var eggTableViewController: EggTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dragRecognizer = DNDLongPressDragRecognizer()
        dragRecognizer.minimumPressDuration = 0.1
        eggTableViewController?.tableView.panGestureRecognizer.requireGestureRecognizerToFail(dragRecognizer)
        
        dragAndDropController.registerDragSource(eggTableViewController?.tableView, withDelegate: self, dragRecognizer: dragRecognizer)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier == "leftView" {
            leftViewController = segue.destinationViewController as? ViewController
        } else if segue.identifier == "rightView" {
            eggTableViewController = segue.destinationViewController as? EggTableViewController
        }
    }
    
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
            
        })
    }
}
