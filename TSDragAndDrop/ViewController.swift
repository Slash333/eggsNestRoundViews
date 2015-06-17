//
//  ViewController.swift
//  TSDragAndDrop
//
//  Created by Igor Ponomarenko on 6/12/15.
//  Copyright (c) 2015 Igor Ponomarenko. All rights reserved.
//


class ViewController: UIViewController, DNDDragSourceDelegate {

    @IBOutlet var dragAndDropController: DNDDragAndDropController!
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
    
    @IBOutlet weak var egg1: RoundViewEgg!
    @IBOutlet weak var egg2: RoundViewEgg!
    @IBOutlet weak var egg3: RoundViewEgg!
    
    lazy var roundViewArray: Array<UIView> = {
        return self.initRoundViewArray()
    } ()
    
    lazy var radiansArray: Array<CGFloat> = {
        return self.initRadiansArray()
    }()
    
    // MARK: overrides
    
    override func viewDidLoad() {
        dragAndDropController.registerDragSource(egg1, withDelegate: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutRoundViews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        observeNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        removeNotificationsObserver()
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
    
    // MARK: notification handlers
    
    func centerPositionChanged(notification: NSNotification) {
        if let roundView = notification.object as? RoundViewEgg {
            
            UIView.animateWithDuration(0.2) {
                roundView.center = roundView.location!
            }
        }
    }
    
    func panGestureEnded(notification: NSNotification) {
        if let roundViewEgg = notification.object as? RoundViewEgg {
            
            if let nestView = roundViewEgg.nest {
                UIView.animateWithDuration(0.7) {
                    roundViewEgg.center = nestView.center
                }
            } else {
                roundViewEgg.goBack()
            }
        }
    }
    
    func gotNest(notification: NSNotification) {
        if let roundViewEgg = notification.object as? RoundViewEgg {
            roundViewEgg.nest!.changeSelectedState(sSelected: true)
        }
    }
    
    func nestDidLose(notification: NSNotification) {
        if let roundViewEgg = notification.object as? RoundViewEgg {
            roundViewEgg.nest!.changeSelectedState(sSelected: false)
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
    
    // MARK: notification center
    
    func observeNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        
        notificationCenter.addObserver(self, selector: "centerPositionChanged:", name: kCenterPositionChanged, object: nil)
        notificationCenter.addObserver(self, selector: "panGestureEnded:", name: kPanGestureEnded, object: nil)
        notificationCenter.addObserver(self, selector: "gotNest:", name: kGotNest, object: nil)
        notificationCenter.addObserver(self, selector: "nestDidLose:", name: kNestDidLose, object: nil)
    }
    
    func removeNotificationsObserver() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self)
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
            draggingView.center = operation.dragSourceView.center
        })
    }
    
}

