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
    
    // Our custom view from the XIB file
    private var view: UIView!
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    //
    
    @IBInspectable var borderColor: UIColor = UIColor.clearColor() {
        didSet {
            view?.layer.borderColor = borderColor.CGColor
            layer.borderColor = borderColor.CGColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            view?.layer.borderWidth = borderWidth
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            view?.layer.cornerRadius = cornerRadius
            layer.cornerRadius = cornerRadius
        }
    }
    
    // load xib
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        
        
        // set properties
        view.layer.borderColor = layer.borderColor
        view.layer.borderWidth = layer.borderWidth
        view.layer.cornerRadius = layer.cornerRadius
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        
        currentColor = view.backgroundColor
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let className = toString(self.dynamicType).componentsSeparatedByString(".").last!
        let nib = UINib(nibName: className, bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
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
            self.view.backgroundColor = selectedColor
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
            self.view.backgroundColor = self.currentColor
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
