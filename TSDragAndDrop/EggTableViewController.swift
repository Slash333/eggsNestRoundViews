//
//  EggTableViewController.swift
//  TSDragAndDrop
//
//  Created by Igor Ponomarenko on 6/17/15.
//  Copyright (c) 2015 Igor Ponomarenko. All rights reserved.
//

import UIKit

class EggTableViewController: UITableViewController, OBOvumSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var cellNib = UINib(nibName: "EggTableViewCell", bundle: nil)
        self.tableView.registerNib(cellNib, forCellReuseIdentifier: "Cell")
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! EggTableViewCell

        cell.nameLabel.text = "1.\(indexPath.row)"
        cell.nameLabe2.text = "2.\(indexPath.row)"
        
        addGesture(cell.eggView)
        addGesture(cell.eggView2)

        return cell
    }
    
    func addGesture(view: UIView) {
        var ddManager = OBDragDropManager.sharedManager()
        var gesture = ddManager.createLongPressDragDropGestureRecognizerWithSource(self)
        
        // remove old gesture
        if  view.gestureRecognizers != nil {
            for gesture in view.gestureRecognizers as! [UIGestureRecognizer] {
                view.removeGestureRecognizer(gesture)
            }
        }
        
        // add new gesture
        view.addGestureRecognizer(gesture)
    }
    
    // MARK: OBOvumSource
    
    func createOvumFromView(sourceView: UIView!) -> OBOvum! {
        var ovum = OBOvum()
        ovum.dataObject = sourceView
        return ovum
    }
    
    func createDragRepresentationOfSourceView(sourceView: UIView!, inWindow window: UIWindow!) -> UIView! {
        var draggingView = NSBundle.mainBundle().loadNibNamed("GhostEgg", owner: nil, options: nil).first as! GhostEgg
        
        var frame = sourceView.convertRect(sourceView.bounds, toView: sourceView.window)
        frame = window.convertRect(frame, fromWindow: sourceView.window)
        draggingView.frame = frame
        
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
}
