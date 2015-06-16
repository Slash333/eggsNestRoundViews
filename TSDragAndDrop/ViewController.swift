//
//  ViewController.swift
//  TSDragAndDrop
//
//  Created by Igor Ponomarenko on 6/12/15.
//  Copyright (c) 2015 Igor Ponomarenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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
    
    var roundViewArray: Array<UIView> = []
    
    lazy var radiansArray: Array<CGFloat> = {
        
        let count = 12
        let angleDelta: CGFloat = CGFloat(360/count)
        var radiansArray: Array<CGFloat> = []
        
        for i in 0..<count {
            var angle: CGFloat = angleDelta * CGFloat(i)
            radiansArray.append(angle.radians)
        }
        
        return radiansArray;
        }()
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutRoundViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // array of views
        roundViewArray = [roundView1,
            roundView2, roundView3,
            roundView4, roundView5,
            roundView6, roundView7,
            roundView8,roundView9,
            roundView10, roundView11,
            roundVIew12]
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("centerPositionChanged:"), name: kCenterPositionChanged, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("panGestureEnded:"), name: kPanGestureEnded, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("gotNest:"), name: kGotNest, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("nestDidLose:"), name: kNestDidLose, object: nil)
        
        layoutRoundViews()
        
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
}

