//
//  Utils.swift
//  TSDragAndDrop
//
//  Created by Igor Ponomarenko on 6/16/15.
//  Copyright (c) 2015 Igor Ponomarenko. All rights reserved.
//

import UIKit

func circlesInsideFramesIntersects(rect1: CGRect, rect2: CGRect) -> Bool {
    
    let r1 = rect1.size.width / 2
    let x1 = rect1.origin.x + r1
    let y1 = rect1.origin.y + r1
    
    let r2 = rect2.size.width / 2
    let x2 = rect2.origin.x + r2
    let y2 = rect2.origin.y + r2
    
    let d = sqrt(pow(x1 - x2, 2) + pow(y1 - y2, 2))
    
    let intersects = r1 + r2 >= d
    let oneCircleInsideAnother = abs(r1 - r2) > d
    
    return intersects || oneCircleInsideAnother;
}