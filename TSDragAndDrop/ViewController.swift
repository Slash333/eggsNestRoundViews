//
//  ViewController.swift
//  TSDragAndDrop
//
//  Created by Igor Ponomarenko on 6/12/15.
//  Copyright (c) 2015 Igor Ponomarenko. All rights reserved.
//


class ViewController: UIViewController, OBOvumSource, OBDropZone/*, DNDDragSourceDelegate, DNDDropTargetDelegate*/ {
    @IBOutlet var DDController: DNDDragAndDropController!
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
    
    lazy var roundViewArray: Array<UIView> = {
        return self.initRoundViewArray()
    } ()
    
    lazy var radiansArray: Array<CGFloat> = {
        return self.initRadiansArray()
    }()
    
    // MARK: overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dragRecognizer = DNDLongPressDragRecognizer()
        dragRecognizer.minimumPressDuration = 0.1
        
        //DDController.registerDragSource(roundView1, withDelegate: self, dragRecognizer: dragRecognizer)
        //DDController.registerDropTarget(self.view, withDelegate: self)
        
        var ddManager = OBDragDropManager.sharedManager()
        
        var gesture = ddManager.createDragDropGestureRecognizerWithClass(UIPanGestureRecognizer.self, source: self)
        roundView1.addGestureRecognizer(gesture)
        
        roundView2.dropZoneHandler = self
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
        //ovum.dataObject = NSNumber(integer: sourceView.tag)
        return ovum
    }
    
    func createDragRepresentationOfSourceView(sourceView: UIView!, inWindow window: UIWindow!) -> UIView! {
        //var draggingView = NSBundle.mainBundle().loadNibNamed("GhostEgg", owner: nil, options: nil).first as! GhostEgg
        var draggingView = UIView(frame: CGRectMake(100, 100, 70, 70))
        draggingView.backgroundColor = UIColor.greenColor()
        //view.addSubview(draggingView)
        
        
        
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
    
    func ovumMoved(ovum: OBOvum!, inView view: UIView!, atLocation location: CGPoint) -> OBDropAction {
        NSLog("ovumMoved");
        
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

