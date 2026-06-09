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
    func stickerViewDidTapContentView(stickerView: IRStickerView)

    func stickerView(stickerView: IRStickerView, imageForLeftTopControl recommendedSize: CGSize) -> UIImage?

    func stickerViewDidTapLeftTopControl(stickerView: IRStickerView) // Effective when image is provided.

    func stickerView(stickerView: IRStickerView, imageForRightTopControl recommendedSize: CGSize) -> UIImage?

    func stickerViewDidTapRightTopControl(stickerView: IRStickerView) // Effective when image is provided.

    func stickerView(stickerView: IRStickerView, imageForLeftBottomControl recommendedSize: CGSize) -> UIImage?

    func stickerViewDidTapLeftBottomControl(stickerView: IRStickerView) // Effective when image is provided.

    func stickerView(stickerView: IRStickerView, imageForRightBottomControl recommendedSize: CGSize) -> UIImage?

    func stickerViewDidTapRightBottomControl(stickerView: IRStickerView) // Effective when image is provided.
}

public extension IRStickerViewDelegate {
    func stickerViewDidTapContentView(stickerView: IRStickerView) {}

    func stickerView(stickerView: IRStickerView, imageForLeftTopControl recommendedSize: CGSize) -> UIImage? {
        return stickerView.leftTopControl.image
    }

    func stickerViewDidTapLeftTopControl(stickerView: IRStickerView) {
        stickerView.removeFromSuperview()
    }

    func stickerView(stickerView: IRStickerView, imageForRightTopControl recommendedSize: CGSize) -> UIImage? {
        return stickerView.rightTopControl.image
    }

    func stickerViewDidTapRightTopControl(stickerView: IRStickerView) {}

    func stickerView(stickerView: IRStickerView, imageForLeftBottomControl recommendedSize: CGSize) -> UIImage? {
        return stickerView.leftBottomControl.image
    }

    func stickerViewDidTapLeftBottomControl(stickerView: IRStickerView) {}

    func stickerView(stickerView: IRStickerView, imageForRightBottomControl recommendedSize: CGSize) -> UIImage? {
        return stickerView.rightBottomControl.image
    }

    func stickerViewDidTapRightBottomControl(stickerView: IRStickerView) {}
}

public class IRStickerView: UIView, UIGestureRecognizerDelegate {

    public var stickerMinScale: CGFloat = 0.5

    public var stickerMaxScale: CGFloat = 2.0

    public var enabledControl: Bool = true // determine the control view is shown or not, default is YES
    {
        didSet {
            controlViews.forEach { $0.isHidden = !enabledControl }
        }
    }
    public var enabledShakeAnimation: Bool = true // default is YES
    public var enabledBorder: Bool = true // default is YES
    {
        didSet {
            if enabledBorder {
                self.contentView.layer.addSublayer(self.shapeLayer)
            } else {
                self.shapeLayer.removeFromSuperlayer()
            }
        }
    }

    public var contentImage: UIImage? {
        didSet {
            self.applyContentImage()
        }
    }

    public weak var delegate: IRStickerViewDelegate? {
        didSet {
            self.applyDelegate()
        }
    }

    let stickerControlViewSize: CGFloat
    private var stickerHalfControlViewSize: CGFloat {
        return stickerControlViewSize / 2
    }

    lazy var contentView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: stickerHalfControlViewSize, y: stickerHalfControlViewSize, width: frame.size.width, height: frame.size.height))
        return imageView
    }()

    lazy var leftTopControl: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: self.contentView.center.x - self.contentView.bounds.size.width / 2 - stickerHalfControlViewSize, y: self.contentView.center.y - self.contentView.bounds.size.height / 2 - stickerHalfControlViewSize, width: stickerControlViewSize, height: stickerControlViewSize))
        imageView.image = UIImage.imageNamedForCurrentBundle(name: "IRSticker.bundle/btn_delete.png")
        return imageView
    }()

    lazy var rightTopControl: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: self.contentView.center.x + self.contentView.bounds.size.width / 2 - stickerHalfControlViewSize, y: self.contentView.center.y - self.contentView.bounds.size.height / 2 - stickerHalfControlViewSize, width: stickerControlViewSize, height: stickerControlViewSize))
        imageView.image = UIImage.imageNamedForCurrentBundle(name: "IRSticker.bundle/btn_smile.png")
        return imageView
    }()

    lazy var leftBottomControl: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: self.contentView.center.x - self.contentView.bounds.size.width / 2 - stickerHalfControlViewSize, y: self.contentView.center.y + self.contentView.bounds.size.height / 2 - stickerHalfControlViewSize, width: stickerControlViewSize, height: stickerControlViewSize))
        imageView.image = UIImage.imageNamedForCurrentBundle(name:"IRSticker.bundle/btn_flip.png")
        return imageView
    }()

    lazy var rightBottomControl: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: self.contentView.center.x + self.contentView.bounds.size.width / 2 - stickerHalfControlViewSize, y: self.contentView.center.y + self.contentView.bounds.size.height / 2 - stickerHalfControlViewSize, width: stickerControlViewSize, height: stickerControlViewSize))
        imageView.image = UIImage.imageNamedForCurrentBundle(name: "IRSticker.bundle/btn_resize.png")
        return imageView
    }()

    lazy var shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        let shapeRect = self.contentView.frame
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: self.contentView.frame.size.width / 2, y: self.contentView.frame.size.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 2.0
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.allowsEdgeAntialiasing = true
        shapeLayer.lineDashPattern = [5, 3]

        let path: CGMutablePath = CGMutablePath()
        path.addRect(shapeRect)
        shapeLayer.path = path
        return shapeLayer
    }()

    /// All four corner controls, ordered left-top, right-top, left-bottom, right-bottom.
    private var controlViews: [UIImageView] {
        [leftTopControl, rightTopControl, leftBottomControl, rightBottomControl]
    }

    private(set) var enableLeftTopControl: Bool
    private(set) var enableRightTopControl: Bool
    private(set) var enableLeftBottomControl: Bool
    private(set) var enableRightBottomControl: Bool

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

        super.init(frame: CGRect(x: frame.origin.x - stickerHalfControlViewSize, y: frame.origin.y - stickerHalfControlViewSize, width: frame.size.width + stickerControlViewSize, height: frame.size.height + stickerControlViewSize))

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

    private func setupConfig() {
        self.isExclusiveTouch = true

        self.isUserInteractionEnabled = true
        self.contentView.isUserInteractionEnabled = true
        controlViews.forEach { $0.isUserInteractionEnabled = true }

        self.enableRightTopControl = false
        self.enableLeftBottomControl = false
        self.enableLeftTopControl = true
        self.enableRightBottomControl = true
        self.enabledControl = true

        self.enabledShakeAnimation = true
        self.enabledBorder = true
    }

    private func attachGestures() {
        // ContentView
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate(gesture:)))
        rotateGesture.delegate = self
        self.contentView.addGestureRecognizer(rotateGesture)

        let pinGesture = UIPinchGestureRecognizer(target: self, action: #selector(handleScale(gesture:)))
        pinGesture.delegate = self
        self.contentView.addGestureRecognizer(pinGesture)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleMove(gesture:)))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        panGesture.delegate = self
        self.contentView.addGestureRecognizer(panGesture)

        // Tap recognizers share the same handler; the handler differentiates by gesture.view.
        addTapRecognizer(to: self.contentView)
        addTapRecognizer(to: self.leftTopControl)
        addTapRecognizer(to: self.rightTopControl)
        addTapRecognizer(to: self.leftBottomControl)

        // ResizeControl (single-hand scale + rotate) plus a tap.
        let singleHandGesture = IRStickerGestureRecognizer(target: self, action: #selector(handleSingleHandAction(gesture:)), anchorView: self.contentView)
        self.rightBottomControl.addGestureRecognizer(singleHandGesture)
        addTapRecognizer(to: self.rightBottomControl)
    }

    private func addTapRecognizer(to view: UIView) {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.delegate = self
        view.addGestureRecognizer(tapRecognizer)
    }
}

// MARK: - Handle Gestures
extension IRStickerView {

    @objc private func handleTap(gesture: UITapGestureRecognizer) {
        switch gesture.view {
        case self.contentView:
            self.handleTapContentView()
        case self.leftTopControl:
            if self.enableLeftTopControl {
                self.delegate?.stickerViewDidTapLeftTopControl(stickerView: self)
            }
        case self.rightTopControl:
            if self.enableRightTopControl {
                self.delegate?.stickerViewDidTapRightTopControl(stickerView: self)
            }
        case self.leftBottomControl:
            if self.enableLeftBottomControl {
                self.delegate?.stickerViewDidTapLeftBottomControl(stickerView: self)
            }
        case self.rightBottomControl:
            if self.enableRightBottomControl {
                self.delegate?.stickerViewDidTapRightBottomControl(stickerView: self)
            }
        default:
            break
        }
    }

    private func handleTapContentView() {
        self.superview?.bringSubviewToFront(self)
        // Perform animation
        if self.enabledShakeAnimation {
            self.performShakeAnimation(targetView: self)
        }
        self.delegate?.stickerViewDidTapContentView(stickerView: self)
    }

    @objc private func handleMove(gesture: UIPanGestureRecognizer) {
        guard let superview = self.superview else {
            return
        }
        let translation = gesture.translation(in: superview)
        let proposedCenter = CGPoint(x: self.center.x + translation.x, y: self.center.y + translation.y)
        self.center = boundedCenter(proposedCenter, in: superview.bounds.size)
        gesture.setTranslation(CGPoint.zero, in: superview)
    }

    @objc private func handleScale(gesture: UIPinchGestureRecognizer) {
        let scale = clampedScale(gesture.scale, currentScale: currentContentScale())
        self.contentView.transform = self.contentView.transform.scaledBy(x: scale, y: scale)
        gesture.scale = 1

        relocalControlView()
    }

    @objc private func handleRotate(gesture: UIRotationGestureRecognizer) {
        self.contentView.transform = self.contentView.transform.rotated(by: gesture.rotation)
        gesture.rotation = 0

        relocalControlView()
    }

    @objc private func handleSingleHandAction(gesture: IRStickerGestureRecognizer) {
        let scale = clampedScale(gesture.scale, currentScale: currentContentScale())
        self.contentView.transform = self.contentView.transform.scaledBy(x: scale, y: scale)
        self.contentView.transform = self.contentView.transform.rotated(by: gesture.rotation)
        gesture.resetGesture()

        relocalControlView()
    }

    /// Clamp a proposed pinch/zoom factor so the resulting absolute scale stays
    /// within `[stickerMinScale, stickerMaxScale]`. When both limits are zero the
    /// proposed scale is returned unchanged (scaling is unbounded).
    func clampedScale(_ scale: CGFloat, currentScale: CGFloat) -> CGFloat {
        guard !(stickerMinScale == 0 && stickerMaxScale == 0) else {
            return scale
        }
        let projected = scale * currentScale
        if projected <= stickerMinScale {
            return stickerMinScale / currentScale
        } else if projected >= stickerMaxScale {
            return stickerMaxScale / currentScale
        }
        return scale
    }

    /// Clamp a center point so the sticker stays anchored within `size`.
    func boundedCenter(_ center: CGPoint, in size: CGSize) -> CGPoint {
        CGPoint(
            x: min(max(0, center.x), size.width),
            y: min(max(0, center.y), size.height)
        )
    }

    private func relocalControlView() {
        let transform = self.contentView.transform
        let originalCenter = self.contentView.center.applying(transform.inverted())
        let halfWidth = self.contentView.bounds.size.width / 2.0
        let halfHeight = self.contentView.bounds.size.height / 2.0

        func cornerCenter(dx: CGFloat, dy: CGFloat) -> CGPoint {
            CGPoint(x: originalCenter.x + dx * halfWidth, y: originalCenter.y + dy * halfHeight).applying(transform)
        }

        self.rightBottomControl.center = cornerCenter(dx: 1, dy: 1)
        self.leftTopControl.center = cornerCenter(dx: -1, dy: -1)
        self.rightTopControl.center = cornerCenter(dx: 1, dy: -1)
        self.leftBottomControl.center = cornerCenter(dx: -1, dy: 1)
    }

    // MARK: - Other
    private func performShakeAnimation(targetView: UIView) {
        targetView.layer.removeAnimation(forKey: "anim")
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.duration = 0.5
        animation.values = [
            NSValue(caTransform3D: targetView.layer.transform),
            NSValue(caTransform3D: CATransform3DScale(targetView.layer.transform, 1.05, 1.05, 1.0)),
            NSValue(caTransform3D: CATransform3DScale(targetView.layer.transform, 0.95, 0.95, 1.0)),
            NSValue(caTransform3D: targetView.layer.transform)
        ]
        animation.isRemovedOnCompletion = true
        targetView.layer.add(animation, forKey:"anim")
    }

    public func performTapOperation() {
        self.handleTapContentView()
    }

    func currentContentScale() -> CGFloat {
        let transform = self.contentView.transform
        return sqrt(transform.a * transform.a + transform.c * transform.c)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension IRStickerView {

    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.view == self.rightBottomControl && gestureRecognizer.isKind(of: IRStickerGestureRecognizer.self) {
            if self.enableRightBottomControl {
                self.delegate?.stickerViewDidTapRightBottomControl(stickerView: self)
                return false
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
            let enabledControls: [(enabled: Bool, view: UIImageView)] = [
                (enableLeftTopControl, leftTopControl),
                (enableRightTopControl, rightTopControl),
                (enableLeftBottomControl, leftBottomControl),
                (enableRightBottomControl, rightBottomControl)
            ]
            for control in enabledControls where control.enabled {
                if control.view.point(inside: self.convert(point, to: control.view), with: event) {
                    return control.view
                }
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

    private func applyDelegate() {
        let recommendedSize = CGSize(width: stickerControlViewSize, height: stickerControlViewSize)
        enableLeftTopControl = apply(image: delegate?.stickerView(stickerView: self, imageForLeftTopControl: recommendedSize), to: leftTopControl)
        enableRightTopControl = apply(image: delegate?.stickerView(stickerView: self, imageForRightTopControl: recommendedSize), to: rightTopControl)
        enableLeftBottomControl = apply(image: delegate?.stickerView(stickerView: self, imageForLeftBottomControl: recommendedSize), to: leftBottomControl)
        enableRightBottomControl = apply(image: delegate?.stickerView(stickerView: self, imageForRightBottomControl: recommendedSize), to: rightBottomControl)
    }

    /// Assign `image` to `control` and report whether the control should be enabled.
    @discardableResult
    private func apply(image: UIImage?, to control: UIImageView) -> Bool {
        control.image = image
        return image != nil
    }

    private func applyContentImage() {
        self.contentView.image = contentImage
    }
}
