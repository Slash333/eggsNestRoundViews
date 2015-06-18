//
//  EggTableViewController.swift
//  TSDragAndDrop
//
//  Created by Igor Ponomarenko on 6/17/15.
//  Copyright (c) 2015 Igor Ponomarenko. All rights reserved.
//

import UIKit

class EggTableViewController: UITableViewController {

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
        var mainVC = self.parentViewController as? MainViewController
        var gesture = ddManager.createLongPressDragDropGestureRecognizerWithSource(mainVC)
        
        if  view.gestureRecognizers != nil {
            for gesture in view.gestureRecognizers as! [UIGestureRecognizer] {
                view.removeGestureRecognizer(gesture)
            }
        }
        
        view.addGestureRecognizer(gesture)
    }
}
