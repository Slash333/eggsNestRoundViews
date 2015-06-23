//
//  ViewController.swift
//  TSDragAndDrop
//
//  Created by Igor Ponomarenko on 6/12/15.
//  Copyright (c) 2015 Igor Ponomarenko. All rights reserved.
//

let kNestCount = 12

class ViewController: UIViewController, OBOvumSource, OBDropZone {
    @IBOutlet weak var roundView: RoundView!
    @IBOutlet weak var trashView: RoundViewTrash!
    
    lazy var roundViewArray: [UIView] = {
        return self.initRoundViewArray()
    } ()
    
    lazy var radiansArray: [CGFloat] = {
        return self.initRadiansArray()
    }()
    
    // MARK: overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add nests
        for nest in roundViewArray {
            view.addSubview(nest)
        }
        
        // set up drop zone
        for roundView in roundViewArray {
            roundView.dropZoneHandler = self
        }
        
        view.dropZoneHandler = self
        trashView.dropZoneHandler = self
        trashView.hidden = true
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
    
    func initRoundViewArray() -> [UIView] {
        
        var roundViewArray = [UIView]()
        
        for i in 0..<kNestCount {
            let frame = CGRectMake(0, 0, 70, 70)
            let nest = RoundViewNest(frame: frame)
            nest.nameLabel.text = "nest \(i)"
            roundViewArray.append(nest)
        }
        
        return roundViewArray
    }
    
    func initRadiansArray() -> [CGFloat] {
        var radiansArray = [CGFloat]()
        
        let angleDelta: CGFloat = CGFloat(360/kNestCount)
        
        for i in 0..<kNestCount {
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
        let frame = CGRectMake(0, 0, 70, 70)
        var ghostEgg = GhostEgg(frame: frame)
        
        var center = window.convertPoint(sourceView.center, fromWindow: sourceView.window)
        ghostEgg.center = center
        
        if let nest = sourceView as? RoundViewNest {
            ghostEgg.egg = nest.egg
        }
        
        return ghostEgg
    }
    
    func dragViewWillAppear(dragView: UIView!, inWindow window: UIWindow!, atLocation location: CGPoint) {
        if let ghostEgg = dragView as? GhostEgg {
            ghostEgg.showAppearAnimation()
        }
        
        trashView.lazyShowWithAnimation()
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
                
                trashView.hideWithAnimation()
            }
            
            return
        }
        
        if view == trashView {
            trashView.changeSelectedState(sSelected: false)
            
            // clear nest
            if let ovumNest = ovum.dataObject as? RoundViewNest {
                clearNest(ovumNest)
            }
            
            trashView.hideWithAnimation()
        }
    }
    
    func ovumEntered(ovum: OBOvum!, inView view: UIView!, atLocation location: CGPoint) -> OBDropAction {
        if let nest = view as? RoundViewNest {
            
            trashView.lazyHideWithAnimation()
            
            if nest.egg == nil {
                nest.changeSelectedState(sSelected: true)
            }
            
            return OBDropAction.Move
        }
        
        if view == trashView {
            if let let ovumNest = ovum.dataObject as? RoundViewNest {
                trashView.changeSelectedState(sSelected: true)
                return OBDropAction.Move
            }
        }
        
        return OBDropAction.None
    }
    
    func ovumExited(ovum: OBOvum!, inView view: UIView!, atLocation location: CGPoint) {
        if let nest = view as? RoundViewNest {
            if let let ovumNest = ovum.dataObject as? RoundViewNest {
                trashView.lazyShowWithAnimation()
            }
            
            nest.changeSelectedState(sSelected: false)
        }
        
        if view == trashView {
            trashView.changeSelectedState(sSelected: false)
        }
    }
    
    func ovumDragEnded(ovum: OBOvum!) {
        trashView.lazyHideWithAnimation()
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
}

