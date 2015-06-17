//
//  Extensions.swift
//  TSDragAndDrop
//
//  Created by Igor Ponomarenko on 6/15/15.
//  Copyright (c) 2015 Igor Ponomarenko. All rights reserved.
//

import Foundation
import UIKit

let π = CGFloat(M_PI)

public extension CGFloat {
    
    var degrees:CGFloat {
        return self * 180 / π;
    }
    
    var radians:CGFloat {
        return self * π / 180;
    }
    
    var rad2deg:CGFloat {
        return self.degrees
    }
    
    var deg2rad:CGFloat {
        return self.radians
    }
}


extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.nextResponder()
            if parentResponder is UIViewController {
                return parentResponder as! UIViewController!
            }
        }
        return nil
    }
}