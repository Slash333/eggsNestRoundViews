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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        currentColor = self.backgroundColor
        
        var cornerRadius = bounds.width / 2
        
        layer.cornerRadius = cornerRadius
        layer.borderWidth = 2
        layer.borderColor = UIColor.blueColor().CGColor
    }
    
    func changeSelectedState(sSelected selected: Bool) {
        self.selected = selected
        
        if selected {
            animateSelection()
            
        } else {
            animateDeslection()
        }
    }
    
    func animateSelection () {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.backgroundColor = selectedColor
            self.transform = CGAffineTransformMakeScale(1.5, 1.5);
            }) { (completed: Bool) -> Void in
                
                if (self.selected) {
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        self.transform = CGAffineTransformMakeScale(1.2, 1.2);
                    })
                }
                
        }
    }
    
    func animateDeslection() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.backgroundColor = self.currentColor
            self.transform = CGAffineTransformMakeScale(1, 1);
            }) { (completed: Bool) -> Void in
                
                if (!self.selected) {
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        self.transform = CGAffineTransformMakeScale(1, 1);
                    })
                }
        }
    }
}
