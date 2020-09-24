//
//  ViewController.swift
//  demo
//
//  Created by Phil on 2020/9/16.
//  Copyright © 2020 Phil. All rights reserved.
//

import UIKit
import IRSticker_swift

class ViewController: UIViewController, IRStickerViewDelegate {
    
    var selectedSticker: IRStickerView?

    var animator: UIDynamicAnimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initial()
    }

    func initial() {
        self.animator = UIDynamicAnimator.init(referenceView: self.view)
        self.view.backgroundColor = .lightGray
        
        var tapRecognizer = UITapGestureRecognizer.init(target: self, action:#selector(tapBackground(recognizer:)))
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
        
        let sticker1 = IRStickerView.init(frame: CGRect.init(x: 0, y: 0, width: 150, height: 150), contentImage: UIImage.init(named: "sticker1.png")!)
        sticker1.center = self.view.center
        sticker1.enabledControl = false
        sticker1.enabledBorder = false
        sticker1.tag = 1
        sticker1.delegate = self
        self.view.addSubview(sticker1)
        
        var sticker2 = IRStickerView.init(frame: CGRect.init(x: 0, y: 0, width: 150, height: 150), contentImage: UIImage.init(named: "sticker2.png")!)
        sticker2.center = self.view.center
        sticker2.enabledControl = false
        sticker2.enabledBorder = false
        sticker2.tag = 2
        sticker2.delegate = self
        self.view.addSubview(sticker2)
        
        var sticker3 = IRStickerView.init(frame: CGRect.init(x: 0, y: 0, width: 150, height: 150), contentImage: UIImage.init(named: "sticker3.png")!)
        sticker3.center = self.view.center
        sticker3.enabledControl = false
        sticker3.enabledBorder = false
        sticker3.tag = 3
        sticker3.delegate = self
        self.view.addSubview(sticker3)
        
        sticker1.performTapOperation()
    }

    @objc func tapBackground(recognizer: UITapGestureRecognizer) {
        if (self.selectedSticker != nil) {
            self.selectedSticker!.enabledControl = false
            self.selectedSticker!.enabledBorder = false;
            self.selectedSticker = nil
        }
    }
    
// MARK: - StickerViewDelegate
    func ir_StickerView(stickerView: IRStickerView, imageForRightTopControl recommendedSize: CGSize) -> UIImage? {
        if stickerView.tag == 1 {
            return UIImage.init(named: "btn_smile.png")
        }
        
        return nil
    }
    
    func ir_StickerView(stickerView: IRStickerView, imageForLeftBottomControl recommendedSize: CGSize) -> UIImage? {
        if stickerView.tag == 1 || stickerView.tag == 2 {
            return UIImage.init(named: "btn_flip.png")
        }
        
        return nil
    }
    
    func ir_StickerViewDidTapContentView(stickerView: IRStickerView) {
        NSLog("Tap[%zd] ContentView", stickerView.tag)
        if let selectedSticker = self.selectedSticker {
            selectedSticker.enabledBorder = false
            selectedSticker.enabledControl = false
        }

        self.selectedSticker = stickerView
        self.selectedSticker!.enabledBorder = true
        self.selectedSticker!.enabledControl = true
    }
    
    func ir_StickerViewDidTapLeftTopControl(stickerView: IRStickerView) {
        NSLog("Tap[%zd] DeleteControl", stickerView.tag);
        stickerView.removeFromSuperview()
        for subView in self.view.subviews {
            if subView.isKind(of: IRStickerView.self)  {
                let sticker = subView as! IRStickerView
                sticker.performTapOperation()
                break
            }
        }
    }
    
    func ir_StickerViewDidTapLeftBottomControl(stickerView: IRStickerView) {
        NSLog("Tap[%zd] LeftBottomControl", stickerView.tag);
        let targetOrientation = (stickerView.contentImage?.imageOrientation == UIImage.Orientation.up ? UIImage.Orientation.upMirrored : UIImage.Orientation.up)
        let invertImage = UIImage.init(cgImage: (stickerView.contentImage?.cgImage)!, scale: 1.0, orientation: targetOrientation)
        stickerView.contentImage = invertImage
    }
    
    func ir_StickerViewDidTapRightTopControl(stickerView: IRStickerView) {
        NSLog("Tap[%zd] RightTopControl", stickerView.tag);
        self.animator?.removeAllBehaviors()
        let snapbehavior = UISnapBehavior.init(item: stickerView, snapTo: self.view.center)
        snapbehavior.damping = 0.65;
        self.animator?.addBehavior(snapbehavior)
    }
}

