//
//  RoundViewSocket.swift
//  TSDragAndDrop
//
//  Created by Igor Ponomarenko on 6/15/15.
//  Copyright (c) 2015 Igor Ponomarenko. All rights reserved.
//

import UIKit

let eggColor = UIColor(red: 32.0/255.0, green: 255.0/255.0, blue: 142.0/255.0, alpha: 1)

@IBDesignable class RoundViewNest: RoundView {
    
    @IBOutlet weak var nameLabel: UILabel!
    var egg: RoundViewEgg?
    var previousColor: UIColor? // refactoring
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        previousColor = currentColor
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        previousColor = currentColor
    }

    
    // MARK: overrides
    
    override func changeSelectedState(sSelected selected: Bool) {
        
        if !selected && egg != nil {
            currentColor = eggColor
        } else {
            currentColor = previousColor
        }
        
        super.changeSelectedState(sSelected: selected)
    }
}