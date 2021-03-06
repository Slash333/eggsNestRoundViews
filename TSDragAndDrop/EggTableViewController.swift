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
        
        cell.egg1.nameLabel.text = "1.\(indexPath.row)"
        cell.egg2.nameLabel.text = "2.\(indexPath.row)"
        
        addGesture(cell.egg1)
        addGesture(cell.egg2)
        
        return cell
    }
    
    func addGesture(view: UIView) {
        var ddManager = OBDragDropManager.sharedManager()
        
        // without long press
        var gesture = ddManager.createDragDropGestureRecognizerWithClass(UIPanGestureRecognizer.self, source: self)
        // long press
        //var gesture = ddManager.createLongPressDragDropGestureRecognizerWithSource(self)
        
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
        
        var frame = CGRectMake(0, 0, 70, 70)
        var ghostEgg = GhostEgg(frame: frame)
        
        frame = sourceView.convertRect(sourceView.bounds, toView: sourceView.window)
        frame = window.convertRect(frame, fromWindow: sourceView.window)
        ghostEgg.frame = frame
        
        ghostEgg.egg = sourceView as? RoundViewEgg
        
        return ghostEgg
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
