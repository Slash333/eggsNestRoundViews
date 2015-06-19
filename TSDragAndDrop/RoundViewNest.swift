//
//  RoundViewSocket.swift
//  TSDragAndDrop
//
//  Created by Igor Ponomarenko on 6/15/15.
//  Copyright (c) 2015 Igor Ponomarenko. All rights reserved.
//

import UIKit


class RoundViewNest: RoundView {
    var egg: RoundViewEgg?
    
    // MARK: overrides
    
    override func changeSelectedState(sSelected selected: Bool) {
        super.changeSelectedState(sSelected: selected)
        
        if !selected && egg != nil {
            backgroundColor = UIColor(red: 32.0/255.0, green: 255.0/255.0, blue: 142.0/255.0, alpha: 1)
        }
    }
}