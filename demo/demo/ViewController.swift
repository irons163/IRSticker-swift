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
        animator = UIDynamicAnimator.init(referenceView: view)
        view.backgroundColor = .lightGray
        
        let tapRecognizer = UITapGestureRecognizer.init(target: self, action:#selector(tapBackground(recognizer:)))
        tapRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapRecognizer)
        
        let sticker1 = IRStickerView(frame: CGRect.init(x: 0, y: 0, width: 150, height: 150), contentImage: UIImage.init(named: "sticker1.png")!)
        sticker1.center = view.center
        sticker1.enabledControl = false
        sticker1.enabledBorder = false
        sticker1.tag = 1
        sticker1.delegate = self
        view.addSubview(sticker1)
        
        let sticker2 = IRStickerView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 200), contentImage: UIImage.init(named: "sticker2.png")!, stickerControlViewSize: 50)
        sticker2.center = view.center
        sticker2.stickerMinScale = 0.7
        sticker2.stickerMaxScale = 1.2
        sticker2.enabledControl = false
        sticker2.enabledBorder = false
        sticker2.tag = 2
        sticker2.delegate = self
        view.addSubview(sticker2)
        
        let sticker3 = IRStickerView(frame: CGRect.init(x: 0, y: 0, width: 250, height: 250), contentImage: UIImage.init(named: "sticker3.png")!)
        sticker3.center = view.center
        sticker3.stickerMinScale = 0
        sticker3.stickerMaxScale = 0
        sticker3.enabledControl = false
        sticker3.enabledBorder = false
        sticker3.tag = 3
        sticker3.delegate = self
        view.addSubview(sticker3)
        
        sticker1.performTapOperation()
    }

    @objc func tapBackground(recognizer: UITapGestureRecognizer) {
        if (selectedSticker != nil) {
            selectedSticker!.enabledControl = false
            selectedSticker!.enabledBorder = false;
            selectedSticker = nil
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
        if let selectedSticker = selectedSticker {
            selectedSticker.enabledBorder = false
            selectedSticker.enabledControl = false
        }

        selectedSticker = stickerView
        selectedSticker!.enabledBorder = true
        selectedSticker!.enabledControl = true
    }
    
    func ir_StickerViewDidTapLeftTopControl(stickerView: IRStickerView) {
        NSLog("Tap[%zd] DeleteControl", stickerView.tag);
        stickerView.removeFromSuperview()
        for subView in view.subviews {
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
        animator?.removeAllBehaviors()
        let snapbehavior = UISnapBehavior.init(item: stickerView, snapTo: view.center)
        snapbehavior.damping = 0.65;
        animator?.addBehavior(snapbehavior)
    }
}

