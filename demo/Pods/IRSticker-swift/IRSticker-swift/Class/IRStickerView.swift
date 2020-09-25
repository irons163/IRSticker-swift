//
//  IRStickerView.swift
//  IRSticker-swift
//
//  Created by Phil on 2020/9/16.
//  Copyright © 2020 Phil. All rights reserved.
//

import UIKit

let kStickerControlViewSize: CGFloat = 30
let kStickerHalfControlViewSize: CGFloat = 15

let kStickerMinScale: CGFloat = 0.5
let kStickerMaxScale: CGFloat = 2.0

public class IRStickerView: UIView, UIGestureRecognizerDelegate {
    public var enabledControl: Bool = true // determine the control view is shown or not, default is YES
    {
        didSet {
            self.leftTopControl.isHidden = !self.enabledControl;
            self.rightBottomControl.isHidden = !self.enabledControl;
            self.rightTopControl.isHidden = !self.enabledControl;
            self.leftBottomControl.isHidden = !self.enabledControl;
        }
    }
    public var enabledShakeAnimation: Bool = true // default is YES
    public var enabledBorder: Bool = true // default is YES
    {
        didSet {
            if (self.enabledBorder) {
                self.contentView.layer.addSublayer(self.shapeLayer)
            } else {
                self.shapeLayer.removeFromSuperlayer()
            }
        }
    }

    public var contentImage: UIImage? {
        didSet {
            self.setContentImage(contentImage: self.contentImage)
        }
    }
    
    public weak var delegate: IRStickerViewDelegate? {
        didSet {
            self.setDelegate(delegate: self.delegate)
        }
    }
    
    var contentView: UIImageView!

    var leftTopControl: UIImageView!
    var rightTopControl: UIImageView!
    var leftBottomControl: UIImageView!
    var rightBottomControl: UIImageView!

    var shapeLayer: CAShapeLayer!

    var enableLeftTopControl: Bool
    var enableRightTopControl: Bool
    var enableLeftBottomControl: Bool
    var enableRightBottomControl: Bool
    
    public init(frame: CGRect, contentImage: UIImage) {
        self.enableRightTopControl = false
        self.enableLeftBottomControl = false
        self.enableLeftTopControl = false
        self.enableRightBottomControl = false
        self.enabledControl = false
        
        self.enabledShakeAnimation = false
        self.enabledBorder = false

        super.init(frame: CGRect.init(x: frame.origin.x - kStickerHalfControlViewSize, y: frame.origin.y - kStickerHalfControlViewSize, width: frame.size.width + kStickerControlViewSize, height: frame.size.height + kStickerControlViewSize))

        self.contentView = UIImageView.init(frame: CGRect.init(x: kStickerHalfControlViewSize, y: kStickerHalfControlViewSize, width: frame.size.width, height: frame.size.height))
        defer{
            self.contentImage = contentImage
        }
        self.addSubview(self.contentView)
        
        self.rightBottomControl = UIImageView.init(frame: CGRect.init(x: self.contentView.center.x + self.contentView.bounds.size.width / 2 - kStickerHalfControlViewSize, y: self.contentView.center.y + self.contentView.bounds.size.height / 2 - kStickerHalfControlViewSize, width: kStickerControlViewSize, height: kStickerControlViewSize))
        self.rightBottomControl.image = UIImage.imageNamedForCurrentBundle(name: "IRSticker.bundle/btn_resize.png")
        self.addSubview(self.rightBottomControl)
        
        self.leftTopControl = UIImageView.init(frame: CGRect.init(x: self.contentView.center.x - self.contentView.bounds.size.width / 2 - kStickerHalfControlViewSize, y: self.contentView.center.y - self.contentView.bounds.size.height / 2 - kStickerHalfControlViewSize, width: kStickerControlViewSize, height: kStickerControlViewSize))
        self.leftTopControl.image = UIImage.imageNamedForCurrentBundle(name: "IRSticker.bundle/btn_delete.png")
        self.addSubview(self.leftTopControl)
        
        self.rightTopControl = UIImageView.init(frame: CGRect.init(x: self.contentView.center.x + self.contentView.bounds.size.width / 2 - kStickerHalfControlViewSize, y: self.contentView.center.y - self.contentView.bounds.size.height / 2 - kStickerHalfControlViewSize, width: kStickerControlViewSize, height: kStickerControlViewSize))
        self.rightTopControl.image = UIImage.imageNamedForCurrentBundle(name: "IRSticker.bundle/btn_smile.png")
        self.addSubview(self.rightTopControl)
        
        self.leftBottomControl = UIImageView.init(frame: CGRect.init(x: self.contentView.center.x - self.contentView.bounds.size.width / 2 - kStickerHalfControlViewSize, y: self.contentView.center.y + self.contentView.bounds.size.height / 2 - kStickerHalfControlViewSize, width: kStickerControlViewSize, height: kStickerControlViewSize))
        self.leftBottomControl.image = UIImage.imageNamedForCurrentBundle(name:"IRSticker.bundle/btn_flip.png")
        self.addSubview(self.leftBottomControl)
        
        initShapeLayer()
        setupConfig()
        attachGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initShapeLayer() {
        self.shapeLayer = CAShapeLayer.init()
        let shapeRect = self.contentView.frame
        self.shapeLayer.bounds = shapeRect
        self.shapeLayer.position = CGPoint.init(x: self.contentView.frame.size.width / 2, y: self.contentView.frame.size.height / 2)
        self.shapeLayer.fillColor = UIColor.clear.cgColor
        self.shapeLayer.strokeColor = UIColor.white.cgColor
        self.shapeLayer.lineWidth = 2.0
        self.shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        self.shapeLayer.allowsEdgeAntialiasing = true
        self.shapeLayer.lineDashPattern = [NSNumber.init(value: 5), (3)]
        
        let path: CGMutablePath = CGMutablePath()
        path.addRect(shapeRect)
        self.shapeLayer.path = path
    }
    
    func setupConfig() {
        self.isExclusiveTouch = true
        
        self.isUserInteractionEnabled = true
        self.contentView.isUserInteractionEnabled = true
        self.rightBottomControl.isUserInteractionEnabled = true
        self.leftTopControl.isUserInteractionEnabled = true
        self.rightTopControl.isUserInteractionEnabled = true
        self.leftBottomControl.isUserInteractionEnabled = true
        
        self.enableRightTopControl = false
        self.enableLeftBottomControl = false
        self.enableLeftTopControl = true
        self.enableRightBottomControl = true
        self.enabledControl = true
        
        self.enabledShakeAnimation = true
        self.enabledBorder = true
    }
    
    func attachGestures() {
        // ContentView
        let rotateGesture = UIRotationGestureRecognizer.init(target: self, action: #selector(handleRotate(gesture:)))
        rotateGesture.delegate = self
        self.contentView.addGestureRecognizer(rotateGesture)
        
        let pinGesture = UIPinchGestureRecognizer.init(target: self, action: #selector(handleScale(gesture:)))
        pinGesture.delegate = self
        self.contentView.addGestureRecognizer(pinGesture)
        
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(handleMove(gesture:)))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        panGesture.delegate = self
        self.contentView.addGestureRecognizer(panGesture)
        
        let tapRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(handleTap(gesture:)))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.delegate = self
        self.contentView.addGestureRecognizer(tapRecognizer)
        
        // DeleteControl
        let tapRecognizer2 = UITapGestureRecognizer.init(target: self, action: #selector(handleTap(gesture:)))
        tapRecognizer2.numberOfTapsRequired = 1
        tapRecognizer2.delegate = self
        self.leftTopControl.addGestureRecognizer(tapRecognizer2)
        
        // RightTopControl
        let tapRecognizer3 = UITapGestureRecognizer.init(target: self, action: #selector(handleTap(gesture:)))
        tapRecognizer3.numberOfTapsRequired = 1
        tapRecognizer3.delegate = self
        self.rightTopControl.addGestureRecognizer(tapRecognizer3)
        
        // LeftBottomControl
        let tapRecognizer4 = UITapGestureRecognizer.init(target: self, action: #selector(handleTap(gesture:)))
        tapRecognizer4.numberOfTapsRequired = 1
        tapRecognizer4.delegate = self
        self.leftBottomControl.addGestureRecognizer(tapRecognizer4)
        
        // ResizeControl
        let singleHandGesture = IRStickerGestureRecognizer.init(target: self, action: #selector(handleSingleHandAction(gesture:)), anchorView: self.contentView)
        self.rightBottomControl.addGestureRecognizer(singleHandGesture)
        
        let tapRecognizer5 = UITapGestureRecognizer.init(target: self, action: #selector(handleTap(gesture:)))
        tapRecognizer5.numberOfTapsRequired = 1
        tapRecognizer5.delegate = self
        self.rightBottomControl.addGestureRecognizer(tapRecognizer5)
    }
    
// MARK: - Handle Gestures
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        if gesture.view == self.contentView {
            self.handleTapContentView()
        } else if gesture.view == self.leftTopControl {
            if self.enableLeftTopControl {
                self.delegate?.ir_StickerViewDidTapLeftTopControl(stickerView: self)
            }
        } else if gesture.view == self.rightTopControl {
            if self.enableRightTopControl {
                self.delegate?.ir_StickerViewDidTapRightTopControl(stickerView: self)
            }
        } else if gesture.view == self.leftBottomControl {
            if self.enableLeftBottomControl {
                self.delegate?.ir_StickerViewDidTapLeftBottomControl(stickerView: self)
            }
        } else if gesture.view == self.rightBottomControl {
           if self.enableRightBottomControl {
               self.delegate?.ir_StickerViewDidTapRightBottomControl(stickerView: self)
           }
       }
    }
    
    func handleTapContentView() {
        self.superview?.bringSubviewToFront(self)
        // Perform animation
        if self.enabledShakeAnimation {
            self.performShakeAnimation(targetView: self)
        }
        self.delegate?.ir_StickerViewDidTapContentView(stickerView: self)
    }
    
    @objc func handleMove(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        // Boundary detection
        var targetPoint = CGPoint.init(x: self.center.x + translation.x, y: self.center.y + translation.y)
        targetPoint.x = max(0, targetPoint.x)
        targetPoint.y = max(0, targetPoint.y)
        targetPoint.x = min(self.superview!.bounds.size.width, targetPoint.x)
        targetPoint.y = min(self.superview!.bounds.size.height, targetPoint.y)
        
        self.center = targetPoint
        gesture.setTranslation(CGPoint.zero, in: self.superview)
    }
    
    @objc func handleScale(gesture: UIPinchGestureRecognizer) {
        var scale = gesture.scale;
        // Scale limit
        let currentScale: CGFloat = self.contentView.layer.value(forKeyPath: "transform.scale") as! CGFloat
        if (scale * currentScale <= kStickerMinScale) {
            scale = kStickerMinScale / currentScale;
        } else if (scale * currentScale >= kStickerMaxScale) {
            scale = kStickerMaxScale / currentScale;
        }
        
        self.contentView.transform = self.contentView.transform.scaledBy(x: scale, y: scale)
        gesture.scale = 1;
        
        relocalControlView()
    }
    
    @objc func handleRotate(gesture: UIRotationGestureRecognizer) {
        self.contentView.transform = self.contentView.transform.rotated(by: gesture.rotation)
        gesture.rotation = 0;
        
        relocalControlView()
    }
    
    @objc func handleSingleHandAction(gesture: IRStickerGestureRecognizer) {
        var scale = gesture.scale;
        // Scale limit
        let currentScale: CGFloat = self.contentView.layer.value(forKeyPath: "transform.scale") as! CGFloat
        if (scale * currentScale <= kStickerMinScale) {
            scale = kStickerMinScale / currentScale;
        } else if (scale * currentScale >= kStickerMaxScale) {
            scale = kStickerMaxScale / currentScale;
        }
        
        self.contentView.transform = self.contentView.transform.scaledBy(x: scale, y: scale)
        self.contentView.transform = self.contentView.transform.rotated(by: gesture.rotation)
        gesture.resetGesture()
        
        relocalControlView()
    }
    
    func relocalControlView() {
        let originalCenter = self.contentView.center.applying(self.contentView.transform.inverted())
        self.rightBottomControl.center = CGPoint.init(x: originalCenter.x + self.contentView.bounds.size.width / 2.0, y: originalCenter.y + self.contentView.bounds.size.height / 2.0).applying(self.contentView.transform)
        self.leftTopControl.center = CGPoint.init(x: originalCenter.x - self.contentView.bounds.size.width / 2.0, y: originalCenter.y - self.contentView.bounds.size.height / 2.0).applying(self.contentView.transform)
        self.rightTopControl.center = CGPoint.init(x: originalCenter.x + self.contentView.bounds.size.width / 2.0, y: originalCenter.y - self.contentView.bounds.size.height / 2.0).applying(self.contentView.transform)
        self.leftBottomControl.center = CGPoint.init(x: originalCenter.x - self.contentView.bounds.size.width / 2.0, y: originalCenter.y + self.contentView.bounds.size.height / 2.0).applying(self.contentView.transform)
    }

// MARK: - UIGestureRecognizerDelegate
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.view == self.rightBottomControl && gestureRecognizer.isKind(of: IRStickerGestureRecognizer.self) {
            if self.enableRightBottomControl {
                self.delegate?.ir_StickerViewDidTapRightBottomControl(stickerView: self)
                return false;
            }
        }
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKind(of: UITapGestureRecognizer.self) || otherGestureRecognizer.isKind(of: UITapGestureRecognizer.self) {
            return false
        } else {
            return true
        }
    }
    
// MARK: - Hit Test
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.isHidden || !self.isUserInteractionEnabled || self.alpha < 0.01 {
            return nil
        }
        if self.enabledControl {
            if self.enableLeftTopControl && self.leftTopControl.point(inside: self.convert(point, to: self.leftTopControl), with: event) {
                return self.leftTopControl
            }
            if self.enableRightTopControl && self.rightTopControl.point(inside: self.convert(point, to: self.rightTopControl), with: event) {
                return self.rightTopControl
            }
            if self.enableLeftBottomControl && self.leftBottomControl.point(inside: self.convert(point, to: self.leftBottomControl), with: event) {
                return self.leftBottomControl
            }
            if self.enableRightBottomControl && self.rightBottomControl.point(inside: self.convert(point, to: self.rightBottomControl), with: event) {
                return self.rightBottomControl
            }
        }
        if self.contentView.point(inside: self.convert(point, to: self.contentView), with: event) {
            return self.contentView
        }
        // return nil for other area.
        return nil
    }
    
// MARK: - Other
    func performShakeAnimation(targetView: UIView) {
        targetView.layer.removeAnimation(forKey: "anim")
        let animation = CAKeyframeAnimation.init(keyPath: "transform")
        animation.duration = 0.5
        animation.values = [
            NSValue.init(caTransform3D:targetView.layer.transform),
            NSValue.init(caTransform3D:CATransform3DScale(targetView.layer.transform, 1.05, 1.05, 1.0)),
            NSValue.init(caTransform3D:CATransform3DScale(targetView.layer.transform, 0.95, 0.95, 1.0)),
            NSValue.init(caTransform3D:targetView.layer.transform)
        ]
        animation.isRemovedOnCompletion = true
        targetView.layer.add(animation, forKey:"anim")
    }
    
    public func performTapOperation() {
        self.handleTapContentView()
    }
    
// MARK: - Property

    func setDelegate(delegate: IRStickerViewDelegate?) {
        let leftTopImage = self.delegate?.ir_StickerView(stickerView: self, imageForLeftTopControl: CGSize.init(width: kStickerControlViewSize, height: kStickerControlViewSize))
        self.leftTopControl.image = leftTopImage
        if leftTopImage != nil {
            self.enableLeftTopControl = true
        } else {
            self.enableLeftTopControl = false
        }
        
        let rightTopImage = self.delegate?.ir_StickerView(stickerView: self, imageForRightTopControl: CGSize.init(width: kStickerControlViewSize, height: kStickerControlViewSize))
        self.rightTopControl.image = rightTopImage
        if rightTopImage != nil {
            self.enableRightTopControl = true
        } else {
            self.enableRightTopControl = false
        }
        
        let leftBottomImage = self.delegate?.ir_StickerView(stickerView: self, imageForLeftBottomControl: CGSize.init(width: kStickerControlViewSize, height: kStickerControlViewSize))
        self.leftBottomControl.image = leftBottomImage
        if leftBottomImage != nil {
            self.enableLeftBottomControl = true
        } else {
            self.enableLeftBottomControl = false
        }
        
        let rightBottomImage = self.delegate?.ir_StickerView(stickerView: self, imageForRightBottomControl: CGSize.init(width: kStickerControlViewSize, height: kStickerControlViewSize))
        self.rightBottomControl.image = rightBottomImage
        if rightBottomImage != nil {
            self.enableRightBottomControl = true
        } else {
            self.enableRightBottomControl = false
        }
    }

    func setContentImage(contentImage: UIImage?) {
        self.contentView.image = contentImage;
    }
}

public protocol IRStickerViewDelegate: NSObjectProtocol {
    func ir_StickerViewDidTapContentView(stickerView: IRStickerView)

    func ir_StickerView(stickerView: IRStickerView, imageForLeftTopControl recommendedSize: CGSize) -> UIImage?

    func ir_StickerViewDidTapLeftTopControl(stickerView: IRStickerView) // Effective when image is provided.

    func ir_StickerView(stickerView: IRStickerView, imageForRightTopControl recommendedSize: CGSize) -> UIImage?

    func ir_StickerViewDidTapRightTopControl(stickerView: IRStickerView) // Effective when image is provided.

    func ir_StickerView(stickerView: IRStickerView, imageForLeftBottomControl recommendedSize: CGSize) -> UIImage?

    func ir_StickerViewDidTapLeftBottomControl(stickerView: IRStickerView) // Effective when image is provided.

    func ir_StickerView(stickerView: IRStickerView, imageForRightBottomControl recommendedSize: CGSize) -> UIImage?

    func ir_StickerViewDidTapRightBottomControl(stickerView: IRStickerView) // Effective when image is provided.
}

public extension IRStickerViewDelegate {
    func ir_StickerViewDidTapContentView(stickerView: IRStickerView) {}

    func ir_StickerView(stickerView: IRStickerView, imageForLeftTopControl recommendedSize: CGSize) -> UIImage? { return stickerView.leftTopControl.image }

    func ir_StickerViewDidTapLeftTopControl(stickerView: IRStickerView) {stickerView.removeFromSuperview()}
    
    func ir_StickerView(stickerView: IRStickerView, imageForRightTopControl recommendedSize: CGSize) -> UIImage? { return stickerView.rightTopControl.image }

    func ir_StickerViewDidTapRightTopControl(stickerView: IRStickerView) {}

    func ir_StickerView(stickerView: IRStickerView, imageForLeftBottomControl recommendedSize: CGSize) -> UIImage? { return stickerView.leftBottomControl.image }

    func ir_StickerViewDidTapLeftBottomControl(stickerView: IRStickerView) {}

    func ir_StickerView(stickerView: IRStickerView, imageForRightBottomControl recommendedSize: CGSize) -> UIImage? { return stickerView.rightBottomControl.image }

    func ir_StickerViewDidTapRightBottomControl(stickerView: IRStickerView) {}
}



