//
//  ViewController.swift
//  TSDragAndDrop
//
//  Created by Igor Ponomarenko on 6/12/15.
//  Copyright (c) 2015 Igor Ponomarenko. All rights reserved.
//


class ViewController: UIViewController, OBOvumSource, OBDropZone {
    @IBOutlet weak var roundView: RoundView!
    @IBOutlet weak var roundView1: RoundViewNest!
    @IBOutlet weak var roundView2: RoundViewNest!
    @IBOutlet weak var roundView3: RoundViewNest!
    @IBOutlet weak var roundView4: RoundViewNest!
    @IBOutlet weak var roundView5: RoundViewNest!
    @IBOutlet weak var roundView6: RoundViewNest!
    @IBOutlet weak var roundView7: RoundViewNest!
    @IBOutlet weak var roundView8: RoundViewNest!
    @IBOutlet weak var roundView9: RoundViewNest!
    @IBOutlet weak var roundView10: RoundViewNest!
    @IBOutlet weak var roundView11: RoundViewNest!
    @IBOutlet weak var roundVIew12: RoundViewNest!
    
    @IBOutlet weak var trashNest: RoundViewNest!
    
    lazy var roundViewArray: Array<UIView> = {
        return self.initRoundViewArray()
    } ()
    
    lazy var radiansArray: Array<CGFloat> = {
        return self.initRadiansArray()
    }()
    
    // MARK: overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // drop
        for roundView in roundViewArray {
            roundView.dropZoneHandler = self
        }
        
        self.view.dropZoneHandler = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutRoundViews()
    }
    
    // MARK: layout subviews
    
    func layoutRoundViews() {
        
        // init
        let radius: CGFloat = roundView.bounds.width / 2 + 44
        
        var center = self.roundView.center
        
        for i in 0..<roundViewArray.count {
            let radians = radiansArray[i]
            let roundView = roundViewArray[i]
            
            // convert polar to cartesian
            roundView.center.x = radius * cos(radians) + center.x
            roundView.center.y = radius * sin(radians) + center.y
        }
    }
    
    // MARK: initializers
    
    func initRoundViewArray() -> Array<UIView> {
        
        let roundViewArray: Array<UIView> = [
            roundView1, roundView2,
            roundView3, roundView4,
            roundView5, roundView6,
            roundView7, roundView8,
            roundView9, roundView10,
            roundView11, roundVIew12]
        
        return roundViewArray
    }
    
    func initRadiansArray() -> Array<CGFloat> {
        var radiansArray: Array<CGFloat> = []
        
        let count = 12
        let angleDelta: CGFloat = CGFloat(360/count)
        
        for i in 0..<count {
            var angle: CGFloat = angleDelta * CGFloat(i)
            radiansArray.append(angle.radians)
        }
        
        return radiansArray;
    }
    
    // MARK: OBOvumSource
    
    func createOvumFromView(sourceView: UIView!) -> OBOvum! {
        var ovum = OBOvum()
        ovum.dataObject = sourceView
        return ovum
    }
    
    func createDragRepresentationOfSourceView(sourceView: UIView!, inWindow window: UIWindow!) -> UIView! {
        var draggingView = NSBundle.mainBundle().loadNibNamed("GhostEgg", owner: nil, options: nil).first as! GhostEgg
        
        var center = window.convertPoint(sourceView.center, fromWindow: sourceView.window)
        draggingView.center = center
        
        if let nest = sourceView as? RoundViewNest {
            draggingView.egg = nest.egg
        }
        
        return draggingView
    }
    
    func dragViewWillAppear(dragView: UIView!, inWindow window: UIWindow!, atLocation location: CGPoint) {
        
        dragView.alpha = 0
        
        UIView.animateWithDuration(0.5,
            animations: { () -> Void in
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
            
            if let ghost = ovum.dragView as? GhostEgg {
                
                putEggOnNest(ghost.egg!, nest: nest)
                
                // clear previous nest
                if let ovumPreviousNest = ovum.dataObject as? RoundViewNest {
                    if ovumPreviousNest != nest {
                        clearNest(ovumPreviousNest)
                    }
                }
            }
        } else if view == self.view {
            
            if let nest = ovum.dataObject as? RoundViewNest{
                clearNest(nest)
            }
        }
    }
    
    func ovumEntered(ovum: OBOvum!, inView view: UIView!, atLocation location: CGPoint) -> OBDropAction {
        
        // if nest
        if let nest = view as? RoundViewNest {
            NSLog("entered on nest")
            
            if nest.egg == nil {
                nest.changeSelectedState(sSelected: true)
                return OBDropAction.Move
            }
        }
        
        // if main view
        if view == self.view {
            NSLog("enter main view")
            
            if let nest = ovum.dataObject as? RoundViewNest {
                self.showTrashNest()
                return OBDropAction.Move
            }
        }
        
        return OBDropAction.None
    }
    
    func ovumExited(ovum: OBOvum!, inView view: UIView!, atLocation location: CGPoint) {
        
        // if nest
        if let nest = view as? RoundViewNest {
            NSLog("exited from nest")
            
            if let let ovumNest = ovum.dataObject as? RoundViewNest {
                
                
                if nest == ovumNest && nest.egg != nil {
                    nest.egg = nil
                }
            }
            
            
            nest.changeSelectedState(sSelected: false)
        }
        
        // if main view
        if view == self.view {
            NSLog("exit main view")
            
            if let nest = ovum.dataObject as? RoundViewNest {
                self.hideTrashNest()
            }
        }
    }
    
    // MARK: helpers
    
    func putEggOnNest(egg: RoundViewEgg, nest: RoundViewNest) {
        
        nest.egg = egg
        
        nest.changeSelectedState(sSelected: false)
        
        // add gesture
        var ddManager = OBDragDropManager.sharedManager()
        
        // without long press
        var gesture = ddManager.createDragDropGestureRecognizerWithClass(UIPanGestureRecognizer.self, source: self)
        // long press
        //var gesture = ddManager.createLongPressDragDropGestureRecognizerWithSource(self)
        
        nest.addGestureRecognizer(gesture)
    }
    
    func clearNest(nest: RoundViewNest) {
        nest.egg = nil // alway be nil if ovumExited occured
        
        nest.changeSelectedState(sSelected: false)
        
        // remove gestures
        for gesture in nest.gestureRecognizers as! [UIGestureRecognizer] {
            nest.removeGestureRecognizer(gesture)
        }
    }
    
    // MARK: helpers
    
    func showTrashNest() {
        trashNest.hidden = false
        trashNest.dropZoneHandler = self
        
//        trashNest.alpha = 0
        
//        UIView.animateWithDuration(0.5, animations: { () -> Void in
//            self.trashNest.alpha = 1
//            self.trashNest.hidden = false
//        })
        
//        UIView.animateWithDuration(0.5, delay: 1, options: nil, animations: { () -> Void in
//            self.trashNest.alpha = 1
//            self.trashNest.hidden = false
//        }, completion: nil)
    }
    
    func hideTrashNest() {
        
        //trashNest.hidden = true
        
//        UIView.animateWithDuration(0.5, animations: { () -> Void in
//            self.trashNest.alpha = 0
//            }) { (completed: Bool) -> Void in
//            self.trashNest.hidden = true
//        }
    }
}

