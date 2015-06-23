//
//  GhostEgg.swift
//  TSDragAndDrop
//
//  Created by Igor Ponomarenko on 6/16/15.
//  Copyright (c) 2015 Igor Ponomarenko. All rights reserved.
//

import UIKit

class GhostEgg: RoundView {
    var egg: RoundViewEgg?
    
    //@IBOutlet weak var nameLabel: UILabel!
    
    func showAppearAnimation() {
        alpha = 0
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.alpha = 0.8
            self.transform = CGAffineTransformMakeScale(1.5, 1.5);
            }) { (completed: Bool) -> Void in
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.transform = CGAffineTransformMakeScale(1.2, 1.2);
                })
        }
    }
}