//
//  TicklegestureRecognizer.swift
//  MonkeyPinch
//
//  Created by April Lee on 2014/12/25.
//  Copyright (c) 2014年 april. All rights reserved.
//

import Foundation
import UIKit

class TickleGestureRecognizer : UIGestureRecognizer {
    
    let requiredTickles = 2
    let distanceForTickleGesture:CGFloat = 25.0
    
    enum Direction:Int{
        case DirectionUnknown = 0
        case DirectionLeft
        case DirectionRight
    }
    
    var tickleCount:Int = 0
    var curTickleStart:CGPoint = CGPointZero
    var lastDirection:Direction = .DirectionUnknown
    
    
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        let touch =  touches.anyObject() as UITouch
        self.curTickleStart =  touch.locationInView(self.view)
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        let touch = touches.anyObject() as UITouch
        let ticklePoint = touch.locationInView(self.view)
        
        let moveAmt =  ticklePoint.x - curTickleStart.x
        var curDirection:Direction
        
        if moveAmt < 0{
            curDirection = .DirectionLeft
        }else{
            curDirection = .DirectionRight
            
        }
        
        //moveAmt is a Float, so self.distanceForTickleGesture needs to be a Float also
        if abs(moveAmt) < self.distanceForTickleGesture{
            return
        }
        
        if self.lastDirection == .DirectionUnknown ||
           (self.lastDirection == .DirectionLeft && curDirection == .DirectionRight) ||
           (self.lastDirection == .DirectionRight && curDirection == .DirectionLeft)
        {
            self.tickleCount++
            self.curTickleStart = ticklePoint
            self.lastDirection = curDirection
            
            if self.state == .Possible && self.tickleCount > self.requiredTickles {
                self.state = .Ended
            }
            
        }
    }
    
    override func reset() {
        self.tickleCount = 0
        self.curTickleStart = CGPointZero
        self.lastDirection = .DirectionUnknown
        if self.state == .Possible{
            self.state = .Failed
        }
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        self.reset()
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        self.reset()
    }
}
