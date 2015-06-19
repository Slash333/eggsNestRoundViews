//
//  RoundViewSocket.swift
//  TSDragAndDrop
//
//  Created by Igor Ponomarenko on 6/15/15.
//  Copyright (c) 2015 Igor Ponomarenko. All rights reserved.
//

import UIKit

let eggColor = UIColor(red: 32.0/255.0, green: 255.0/255.0, blue: 142.0/255.0, alpha: 1)

class RoundViewNest: RoundView {
    var egg: RoundViewEgg?
    var realColor: UIColor? // need refactoring
    
    // MARK: overrides
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        realColor = currentColor
    }
    
    override func changeSelectedState(sSelected selected: Bool) {
        
        if !selected && egg != nil {
            currentColor = eggColor
        } else {
            currentColor = realColor
        }
        
        super.changeSelectedState(sSelected: selected)
    }
}