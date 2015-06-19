//
//  RoundView.swift
//  TSDragAndDrop
//
//  Created by Igor Ponomarenko on 6/12/15.
//  Copyright (c) 2015 Igor Ponomarenko. All rights reserved.
//

import UIKit

let selectedColor = UIColor.grayColor()

class RoundView: UIView {
    
    var currentColor: UIColor?
    var selected: Bool = false
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        currentColor = self.backgroundColor
    
        var cornerRadius = bounds.width / 2
        
        layer.cornerRadius = cornerRadius
        layer.borderWidth = 2
        layer.borderColor = UIColor.blueColor().CGColor
    }
    
    func changeSelectedState(sSelected selected: Bool) {
        self.selected = selected
        
        if selected {
            self.backgroundColor = selectedColor
            
            /*
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.transform = CGAffineTransformMakeScale(1.5, 1.5);
                }) { (completed: Bool) -> Void in
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        self.transform = CGAffineTransformMakeScale(1.2, 1.2);
                })
            }
            */
            
        } else {
            self.backgroundColor = currentColor
            /*
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.transform = CGAffineTransformMakeScale(1, 1);
            })
            */
        }
        
    }
}
