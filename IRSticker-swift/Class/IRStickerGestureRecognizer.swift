//
//  IRStickerGestureRecognizer.swift
//  IRSticker-swift
//
//  Created by Phil on 2020/9/16.
//  Copyright © 2020 Phil. All rights reserved.
//

import UIKit

class IRStickerGestureRecognizer: UIGestureRecognizer {
    public var scale: CGFloat = 1
    public var rotation: CGFloat = 0

    var anchorView: UIView!
    
    convenience init(target: Any?, action: Selector?, anchorView: UIView) {
        self.init(target: target, action: action)
        self.anchorView = anchorView
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        // Only support single hand.
        if event.touches(for: self)!.count > 1 {
            self.state = .failed
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        if self.state == .possible {
            self.state = .began
        } else {
            self.state = .changed
        }
        
        let touch = touches.first
        let anchorViewCenter = self.anchorView.center
        let currentPoint = touch?.location(in: self.anchorView.superview)
        let previousPoint = touch?.previousLocation(in: self.anchorView.superview)
        
        let currentRotation = atan2f(Float((currentPoint!.y - anchorViewCenter.y)), Float((currentPoint!.x - anchorViewCenter.x)))
        let previousRotation = atan2f(Float((previousPoint!.y - anchorViewCenter.y)), Float((previousPoint!.x - anchorViewCenter.x)))
        
        let currentRadius = self.distanceBetweenFirstPoint(first: currentPoint!, secondPoint: anchorViewCenter)
        let previousRadius = self.distanceBetweenFirstPoint(first: previousPoint!, secondPoint: anchorViewCenter)
        let scale = currentRadius / previousRadius
        
        self.rotation = CGFloat(currentRotation - previousRotation)
        self.scale = scale;
    }
    
    func distanceBetweenFirstPoint(first: CGPoint, secondPoint second: CGPoint) -> CGFloat {
       let deltaX = second.x - first.x
       let deltaY = second.y - first.y
       return sqrt(deltaX * deltaX + deltaY * deltaY)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        if self.state == .changed {
            self.state = .ended
        } else {
            self.state = .failed
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .failed
    }
    
    public func resetGesture() {
        self.rotation = 0;
        self.scale = 1;
    }
}
