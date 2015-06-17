//
//  ViewController.swift
//  TSDragAndDrop
//
//  Created by Igor Ponomarenko on 6/12/15.
//  Copyright (c) 2015 Igor Ponomarenko. All rights reserved.
//


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
    
    lazy var roundViewArray: Array<UIView> = {
        return self.initRoundViewArray()
    } ()
    
    lazy var radiansArray: Array<CGFloat> = {
        return self.initRadiansArray()
    }()
    
    // MARK: overrides
    
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
}

