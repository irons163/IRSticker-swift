//
//  IRStickerView.swift
//  IRSticker-swift
//
//  Created by Phil on 2020/9/16.
//  Copyright © 2020 Phil. All rights reserved.
//

import UIKit

public let defaultStickerControlViewSize: CGFloat = 30

public protocol IRStickerViewDelegate: NSObjectProtocol {
    @available(*, deprecated, renamed: "stickerViewDidTapContentView")
    func ir_StickerViewDidTapContentView(stickerView: IRStickerView)
    func stickerViewDidTapContentView(stickerView: IRStickerView)

    @available(*, deprecated, renamed: "stickerView")
    func ir_StickerView(stickerView: IRStickerView, imageForLeftTopControl recommendedSize: CGSize) -> UIImage?
    func stickerView(stickerView: IRStickerView, imageForLeftTopControl recommendedSize: CGSize) -> UIImage?

    @available(*, deprecated, renamed: "stickerViewDidTapLeftTopControl")
    func ir_StickerViewDidTapLeftTopControl(stickerView: IRStickerView)
    func stickerViewDidTapLeftTopControl(stickerView: IRStickerView) // Effective when image is provided.

    @available(*, deprecated, renamed: "stickerViewDidTapRightTopControl")
    func ir_StickerViewDidTapRightTopControl(stickerView: IRStickerView)
    func stickerViewDidTapRightTopControl(stickerView: IRStickerView) // Effective when image is provided.

    @available(*, deprecated, renamed: "stickerView")
    func ir_StickerView(stickerView: IRStickerView, imageForLeftBottomControl recommendedSize: CGSize) -> UIImage?
    func stickerView(stickerView: IRStickerView, imageForLeftBottomControl recommendedSize: CGSize) -> UIImage?

    @available(*, deprecated, renamed: "stickerViewDidTapLeftBottomControl")
    func ir_StickerViewDidTapLeftBottomControl(stickerView: IRStickerView)
    func stickerViewDidTapLeftBottomControl(stickerView: IRStickerView) // Effective when image is provided.

    @available(*, deprecated, renamed: "stickerView")
    func ir_StickerView(stickerView: IRStickerView, imageForRightBottomControl recommendedSize: CGSize) -> UIImage?
    func stickerView(stickerView: IRStickerView, imageForRightBottomControl recommendedSize: CGSize) -> UIImage?

    @available(*, deprecated, renamed: "stickerViewDidTapRightBottomControl")
    func ir_StickerViewDidTapRightBottomControl(stickerView: IRStickerView)
    func stickerViewDidTapRightBottomControl(stickerView: IRStickerView) // Effective when image is provided.
}

public extension IRStickerViewDelegate {
    @available(*, deprecated, renamed: "stickerViewDidTapContentView")
    func ir_StickerViewDidTapContentView(stickerView: IRStickerView) {}
    func stickerViewDidTapContentView(stickerView: IRStickerView) { ir_StickerViewDidTapContentView(stickerView: stickerView) }

    @available(*, deprecated, renamed: "stickerView")
    func ir_StickerView(stickerView: IRStickerView, imageForLeftTopControl recommendedSize: CGSize) -> UIImage? { return stickerView.leftTopControl.image }
    func stickerView(stickerView: IRStickerView, imageForLeftTopControl recommendedSize: CGSize) -> UIImage? { return ir_StickerView(stickerView: stickerView, imageForLeftTopControl: recommendedSize) }

    @available(*, deprecated, renamed: "stickerViewDidTapLeftTopControl")
    func ir_StickerViewDidTapLeftTopControl(stickerView: IRStickerView) {stickerView.removeFromSuperview()}
    func stickerViewDidTapLeftTopControl(stickerView: IRStickerView) { ir_StickerViewDidTapLeftTopControl(stickerView: stickerView) }

    @available(*, deprecated, renamed: "stickerView")
    func ir_StickerView(stickerView: IRStickerView, imageForRightTopControl recommendedSize: CGSize) -> UIImage? { return stickerView.rightTopControl.image }
    func stickerView(stickerView: IRStickerView, imageForRightTopControl recommendedSize: CGSize) -> UIImage? { return ir_StickerView(stickerView: stickerView, imageForRightTopControl: recommendedSize) }

    @available(*, deprecated, renamed: "stickerViewDidTapRightTopControl")
    func ir_StickerViewDidTapRightTopControl(stickerView: IRStickerView) {}
    func stickerViewDidTapRightTopControl(stickerView: IRStickerView) { ir_StickerViewDidTapRightTopControl(stickerView: stickerView) }

    @available(*, deprecated, renamed: "stickerView")
    func ir_StickerView(stickerView: IRStickerView, imageForLeftBottomControl recommendedSize: CGSize) -> UIImage? { return stickerView.leftBottomControl.image }
    func stickerView(stickerView: IRStickerView, imageForLeftBottomControl recommendedSize: CGSize) -> UIImage? { return ir_StickerView(stickerView: stickerView, imageForRightTopControl: recommendedSize) }

    @available(*, deprecated, renamed: "stickerViewDidTapLeftBottomControl")
    func ir_StickerViewDidTapLeftBottomControl(stickerView: IRStickerView) {}
    func stickerViewDidTapLeftBottomControl(stickerView: IRStickerView) { ir_StickerViewDidTapLeftBottomControl(stickerView: stickerView) }

    @available(*, deprecated, renamed: "stickerView")
    func ir_StickerView(stickerView: IRStickerView, imageForRightBottomControl recommendedSize: CGSize) -> UIImage? { return stickerView.rightBottomControl.image }
    func stickerView(stickerView: IRStickerView, imageForRightBottomControl recommendedSize: CGSize) -> UIImage? { return ir_StickerView(stickerView: stickerView, imageForRightBottomControl: recommendedSize) }

    @available(*, deprecated, renamed: "stickerViewDidTapRightBottomControl")
    func ir_StickerViewDidTapRightBottomControl(stickerView: IRStickerView) {}
    func stickerViewDidTapRightBottomControl(stickerView: IRStickerView) { ir_StickerViewDidTapRightBottomControl(stickerView: stickerView) }
}

public class IRStickerView: UIView, UIGestureRecognizerDelegate {
    
    public var stickerMinScale: CGFloat = 0.5

    public var stickerMaxScale: CGFloat = 2.0
    
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
    
    var stickerControlViewSize: CGFloat = defaultStickerControlViewSize
    var stickerHalfControlViewSize: CGFloat {
        return stickerControlViewSize / 2
    }
    
    lazy var contentView: UIImageView = {
        let imageView = UIImageView.init(frame: CGRect.init(x: stickerHalfControlViewSize, y: stickerHalfControlViewSize, width: frame.size.width, height: frame.size.height))
        return imageView
    }()

    lazy var leftTopControl: UIImageView = {
        let imageView = UIImageView.init(frame: CGRect.init(x: self.contentView.center.x - self.contentView.bounds.size.width / 2 - stickerHalfControlViewSize, y: self.contentView.center.y - self.contentView.bounds.size.height / 2 - stickerHalfControlViewSize, width: stickerControlViewSize, height: stickerControlViewSize))
        imageView.image = UIImage.imageNamedForCurrentBundle(name: "IRSticker.bundle/btn_delete.png")
        return imageView
    }()

    lazy var rightTopControl: UIImageView = {
        let imageView = UIImageView.init(frame: CGRect.init(x: self.contentView.center.x + self.contentView.bounds.size.width / 2 - stickerHalfControlViewSize, y: self.contentView.center.y - self.contentView.bounds.size.height / 2 - stickerHalfControlViewSize, width: stickerControlViewSize, height: stickerControlViewSize))
        imageView.image = UIImage.imageNamedForCurrentBundle(name: "IRSticker.bundle/btn_smile.png")
        return imageView
    }()

    lazy var leftBottomControl: UIImageView = {
        let imageView = UIImageView.init(frame: CGRect.init(x: self.contentView.center.x - self.contentView.bounds.size.width / 2 - stickerHalfControlViewSize, y: self.contentView.center.y + self.contentView.bounds.size.height / 2 - stickerHalfControlViewSize, width: stickerControlViewSize, height: stickerControlViewSize))
        imageView.image = UIImage.imageNamedForCurrentBundle(name:"IRSticker.bundle/btn_flip.png")
        return imageView
    }()

    lazy var rightBottomControl: UIImageView = {
        let imageView = UIImageView.init(frame: CGRect.init(x: self.contentView.center.x + self.contentView.bounds.size.width / 2 - stickerHalfControlViewSize, y: self.contentView.center.y + self.contentView.bounds.size.height / 2 - stickerHalfControlViewSize, width: stickerControlViewSize, height: stickerControlViewSize))
        imageView.image = UIImage.imageNamedForCurrentBundle(name: "IRSticker.bundle/btn_resize.png")
        return imageView
    }()

    lazy var shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer.init()
        let shapeRect = self.contentView.frame
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint.init(x: self.contentView.frame.size.width / 2, y: self.contentView.frame.size.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 2.0
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.allowsEdgeAntialiasing = true
        shapeLayer.lineDashPattern = [NSNumber.init(value: 5), (3)]

        let path: CGMutablePath = CGMutablePath()
        path.addRect(shapeRect)
        shapeLayer.path = path
        return shapeLayer
    }()

    var enableLeftTopControl: Bool
    var enableRightTopControl: Bool
    var enableLeftBottomControl: Bool
    var enableRightBottomControl: Bool
    
    public init(frame: CGRect, contentImage: UIImage, stickerControlViewSize: CGFloat = defaultStickerControlViewSize) {
        self.stickerControlViewSize = stickerControlViewSize
        self.enableRightTopControl = false
        self.enableLeftBottomControl = false
        self.enableLeftTopControl = false
        self.enableRightBottomControl = false
        self.enabledControl = false
        
        self.enabledShakeAnimation = false
        self.enabledBorder = false
        let stickerHalfControlViewSize = self.stickerControlViewSize / 2

        super.init(frame: CGRect.init(x: frame.origin.x - stickerHalfControlViewSize, y: frame.origin.y - stickerHalfControlViewSize, width: frame.size.width + stickerControlViewSize, height: frame.size.height + stickerControlViewSize))

        defer {
            self.contentImage = contentImage
        }
        
        self.addSubview(self.contentView)
        self.addSubview(self.rightBottomControl)
        self.addSubview(self.leftTopControl)
        self.addSubview(self.rightTopControl)
        self.addSubview(self.leftBottomControl)
        
        setupConfig()
        attachGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Set up
extension IRStickerView {
    
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
}

// MARK: - Handle Gestures
extension IRStickerView {

    @objc func handleTap(gesture: UITapGestureRecognizer) {
        if gesture.view == self.contentView {
            self.handleTapContentView()
        } else if gesture.view == self.leftTopControl {
            if self.enableLeftTopControl {
                self.delegate?.stickerViewDidTapLeftTopControl(stickerView: self)
            }
        } else if gesture.view == self.rightTopControl {
            if self.enableRightTopControl {
                self.delegate?.stickerViewDidTapRightTopControl(stickerView: self)
            }
        } else if gesture.view == self.leftBottomControl {
            if self.enableLeftBottomControl {
                self.delegate?.stickerViewDidTapLeftBottomControl(stickerView: self)
            }
        } else if gesture.view == self.rightBottomControl {
            if self.enableRightBottomControl {
                self.delegate?.stickerViewDidTapRightBottomControl(stickerView: self)
            }
        }
    }
    
    func handleTapContentView() {
        self.superview?.bringSubviewToFront(self)
        // Perform animation
        if self.enabledShakeAnimation {
            self.performShakeAnimation(targetView: self)
        }
        self.delegate?.stickerViewDidTapContentView(stickerView: self)
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
        if (!(stickerMinScale == 0 && stickerMaxScale == 0)) {
            if (scale * currentScale <= stickerMinScale) {
                scale = stickerMinScale / currentScale;
            } else if (scale * currentScale >= stickerMaxScale) {
                scale = stickerMaxScale / currentScale;
            }
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
        if (!(stickerMinScale == 0 && stickerMaxScale == 0)) {
            if (scale * currentScale <= stickerMinScale) {
                scale = stickerMinScale / currentScale;
            } else if (scale * currentScale >= stickerMaxScale) {
                scale = stickerMaxScale / currentScale;
            }
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
}

// MARK: - UIGestureRecognizerDelegate
extension IRStickerView {

    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.view == self.rightBottomControl && gestureRecognizer.isKind(of: IRStickerGestureRecognizer.self) {
            if self.enableRightBottomControl {
                self.delegate?.stickerViewDidTapRightBottomControl(stickerView: self)
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
}

// MARK: - Hit Test
extension IRStickerView {

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
}

// MARK: - Property
extension IRStickerView {

    func setDelegate(delegate: IRStickerViewDelegate?) {
        let leftTopImage = self.delegate?.stickerView(stickerView: self, imageForLeftTopControl: CGSize.init(width: stickerControlViewSize, height: stickerControlViewSize))
        self.leftTopControl.image = leftTopImage
        if leftTopImage != nil {
            self.enableLeftTopControl = true
        } else {
            self.enableLeftTopControl = false
        }
        
        let rightTopImage = self.delegate?.stickerView(stickerView: self, imageForRightTopControl: CGSize.init(width: stickerControlViewSize, height: stickerControlViewSize))
        self.rightTopControl.image = rightTopImage
        if rightTopImage != nil {
            self.enableRightTopControl = true
        } else {
            self.enableRightTopControl = false
        }
        
        let leftBottomImage = self.delegate?.stickerView(stickerView: self, imageForLeftBottomControl: CGSize.init(width: stickerControlViewSize, height: stickerControlViewSize))
        self.leftBottomControl.image = leftBottomImage
        if leftBottomImage != nil {
            self.enableLeftBottomControl = true
        } else {
            self.enableLeftBottomControl = false
        }
        
        let rightBottomImage = self.delegate?.stickerView(stickerView: self, imageForRightBottomControl: CGSize.init(width: stickerControlViewSize, height: stickerControlViewSize))
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
