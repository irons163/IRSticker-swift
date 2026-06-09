import Testing
import UIKit
@testable import IRSticker_swift

// MARK: - Helpers

@MainActor
private func makeImage(size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
    UIGraphicsImageRenderer(size: size).image { _ in }
}

@MainActor
private func makeSticker(
    frame: CGRect = CGRect(x: 10, y: 20, width: 50, height: 60),
    controlSize: CGFloat = defaultStickerControlViewSize
) -> IRStickerView {
    IRStickerView(frame: frame, contentImage: makeImage(), stickerControlViewSize: controlSize)
}

// MARK: - Initialization

@MainActor
struct IRStickerViewInitTests {

    @Test
    func expandsFrameByControlSize() {
        let sticker = IRStickerView(
            frame: CGRect(x: 10, y: 20, width: 50, height: 60),
            contentImage: makeImage()
        )
        // Origin shifts by half the control size; size grows by a full control size.
        #expect(sticker.frame == CGRect(x: -5, y: 5, width: 80, height: 90))
    }

    @Test
    func contentImageIsApplied() {
        let image = makeImage()
        let sticker = IRStickerView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), contentImage: image)
        #expect(sticker.contentImage === image)
        #expect(sticker.contentView.image === image)
    }

    @Test
    func defaultFlagsAfterSetup() {
        let sticker = makeSticker()
        #expect(sticker.enabledControl)
        #expect(sticker.enabledShakeAnimation)
        #expect(sticker.enabledBorder)
        // Only delete (left-top) and resize (right-bottom) controls are active by default.
        #expect(sticker.enableLeftTopControl)
        #expect(sticker.enableRightBottomControl)
        #expect(!sticker.enableRightTopControl)
        #expect(!sticker.enableLeftBottomControl)
    }

    @Test
    func controlsAreSubviewsAndInteractive() {
        let sticker = makeSticker()
        for control in [sticker.leftTopControl, sticker.rightTopControl, sticker.leftBottomControl, sticker.rightBottomControl] {
            #expect(control.superview === sticker)
            #expect(control.isUserInteractionEnabled)
            #expect(!control.isHidden)
        }
        #expect(sticker.contentView.superview === sticker)
    }
}

// MARK: - Scale clamping

@MainActor
struct IRStickerViewScaleTests {

    @Test
    func keepsScaleWithinBounds() {
        let sticker = makeSticker() // min 0.5, max 2.0
        #expect(sticker.clampedScale(1.0, currentScale: 1.0) == 1.0)
    }

    @Test
    func clampsBelowMinimum() {
        let sticker = makeSticker()
        // 0.3 * 1.0 <= 0.5 -> returns min / current
        #expect(sticker.clampedScale(0.3, currentScale: 1.0) == 0.5)
    }

    @Test
    func clampsAboveMaximum() {
        let sticker = makeSticker()
        // 3.0 * 1.0 >= 2.0 -> returns max / current
        #expect(sticker.clampedScale(3.0, currentScale: 1.0) == 2.0)
    }

    @Test
    func accountsForCurrentScale() {
        let sticker = makeSticker()
        // Already at 2x; requesting another 1.5x would reach 3x, clamped back to 2x => factor 1.0
        #expect(sticker.clampedScale(1.5, currentScale: 2.0) == 1.0)
    }

    @Test
    func unboundedWhenBothLimitsZero() {
        let sticker = makeSticker()
        sticker.stickerMinScale = 0
        sticker.stickerMaxScale = 0
        #expect(sticker.clampedScale(5.0, currentScale: 1.0) == 5.0)
    }

    @Test
    func currentContentScaleReflectsTransform() {
        let sticker = makeSticker()
        #expect(abs(sticker.currentContentScale() - 1.0) < 1e-6)
        sticker.contentView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        #expect(abs(sticker.currentContentScale() - 1.5) < 1e-6)
    }
}

// MARK: - Bounded movement

@MainActor
struct IRStickerViewBoundsTests {

    @Test
    func centerInsideBoundsIsUnchanged() {
        let sticker = makeSticker()
        let point = CGPoint(x: 50, y: 80)
        #expect(sticker.boundedCenter(point, in: CGSize(width: 100, height: 200)) == point)
    }

    @Test
    func clampsNegativeCoordinatesToZero() {
        let sticker = makeSticker()
        let result = sticker.boundedCenter(CGPoint(x: -10, y: -20), in: CGSize(width: 100, height: 200))
        #expect(result == CGPoint(x: 0, y: 0))
    }

    @Test
    func clampsToMaximumBounds() {
        let sticker = makeSticker()
        let result = sticker.boundedCenter(CGPoint(x: 150, y: 250), in: CGSize(width: 100, height: 200))
        #expect(result == CGPoint(x: 100, y: 200))
    }
}

// MARK: - enabledControl / enabledBorder

@MainActor
struct IRStickerViewToggleTests {

    @Test
    func disablingControlHidesAllCorners() {
        let sticker = makeSticker()
        sticker.enabledControl = false
        for control in [sticker.leftTopControl, sticker.rightTopControl, sticker.leftBottomControl, sticker.rightBottomControl] {
            #expect(control.isHidden)
        }
        sticker.enabledControl = true
        for control in [sticker.leftTopControl, sticker.rightTopControl, sticker.leftBottomControl, sticker.rightBottomControl] {
            #expect(!control.isHidden)
        }
    }

    @Test
    func borderLayerAttachesAndDetaches() {
        let sticker = makeSticker()
        // Border is enabled by setupConfig, so the shape layer is attached.
        #expect(sticker.shapeLayer.superlayer === sticker.contentView.layer)
        sticker.enabledBorder = false
        #expect(sticker.shapeLayer.superlayer == nil)
        sticker.enabledBorder = true
        #expect(sticker.shapeLayer.superlayer === sticker.contentView.layer)
    }
}

// MARK: - Delegate

@MainActor
private final class SpyDelegate: NSObject, IRStickerViewDelegate {
    var leftTopImage: UIImage?
    var rightTopImage: UIImage?
    var leftBottomImage: UIImage?
    var rightBottomImage: UIImage?

    private(set) var didTapContentView = false
    private(set) var didTapRightBottom = false

    func stickerViewDidTapContentView(stickerView: IRStickerView) {
        didTapContentView = true
    }

    func stickerView(stickerView: IRStickerView, imageForLeftTopControl recommendedSize: CGSize) -> UIImage? {
        leftTopImage
    }

    func stickerView(stickerView: IRStickerView, imageForRightTopControl recommendedSize: CGSize) -> UIImage? {
        rightTopImage
    }

    func stickerView(stickerView: IRStickerView, imageForLeftBottomControl recommendedSize: CGSize) -> UIImage? {
        leftBottomImage
    }

    func stickerView(stickerView: IRStickerView, imageForRightBottomControl recommendedSize: CGSize) -> UIImage? {
        rightBottomImage
    }

    func stickerViewDidTapRightBottomControl(stickerView: IRStickerView) {
        didTapRightBottom = true
    }
}

/// Conforms with no overrides so the protocol's default implementations are exercised.
@MainActor
private final class DefaultDelegate: NSObject, IRStickerViewDelegate {}

@MainActor
struct IRStickerViewDelegateTests {

    @Test
    func assigningDelegateSyncsControlImagesAndFlags() {
        let sticker = makeSticker()
        let delegate = SpyDelegate()
        let lt = makeImage()
        let rt = makeImage()
        delegate.leftTopImage = lt
        delegate.rightTopImage = rt
        delegate.leftBottomImage = nil
        delegate.rightBottomImage = nil

        sticker.delegate = delegate

        #expect(sticker.enableLeftTopControl)
        #expect(sticker.leftTopControl.image === lt)
        #expect(sticker.enableRightTopControl)
        #expect(sticker.rightTopControl.image === rt)
        #expect(!sticker.enableLeftBottomControl)
        #expect(sticker.leftBottomControl.image == nil)
        #expect(!sticker.enableRightBottomControl)
        #expect(sticker.rightBottomControl.image == nil)
    }

    @Test
    func performTapOperationNotifiesDelegate() {
        let sticker = makeSticker()
        let delegate = SpyDelegate()
        sticker.delegate = delegate

        sticker.performTapOperation()

        #expect(delegate.didTapContentView)
    }

    @Test
    func tapContentBringsStickerToFront() {
        let superview = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        let sticker = makeSticker()
        sticker.enabledShakeAnimation = false
        let topMost = UIView()
        superview.addSubview(sticker)
        superview.addSubview(topMost)
        #expect(superview.subviews.last === topMost)

        sticker.performTapOperation()

        #expect(superview.subviews.last === sticker)
    }

    @Test
    func defaultLeftTopHandlerRemovesStickerFromSuperview() {
        let superview = UIView()
        let sticker = makeSticker()
        superview.addSubview(sticker)
        #expect(sticker.superview === superview)

        let delegate = DefaultDelegate()
        delegate.stickerViewDidTapLeftTopControl(stickerView: sticker)

        #expect(sticker.superview == nil)
    }

    @Test
    func resizeGestureShouldBeginNotifiesAndCancels() {
        let sticker = makeSticker()
        let delegate = SpyDelegate()
        delegate.rightBottomImage = makeImage() // enables right-bottom control
        sticker.delegate = delegate
        #expect(sticker.enableRightBottomControl)

        let resizeGesture = sticker.rightBottomControl.gestureRecognizers?
            .first { $0 is IRStickerGestureRecognizer }
        #expect(resizeGesture != nil)

        // Should fire the tap callback and prevent the gesture from beginning.
        let shouldBegin = sticker.gestureRecognizerShouldBegin(resizeGesture!)
        #expect(!shouldBegin)
        #expect(delegate.didTapRightBottom)
    }
}

// MARK: - Hit testing

@MainActor
struct IRStickerViewHitTestTests {

    @Test
    func returnsNilWhenHidden() {
        let sticker = makeSticker()
        sticker.isHidden = true
        #expect(sticker.hitTest(CGPoint(x: 55, y: 60), with: nil) == nil)
    }

    @Test
    func returnsNilWhenTransparent() {
        let sticker = makeSticker()
        sticker.alpha = 0.0
        #expect(sticker.hitTest(CGPoint(x: 55, y: 60), with: nil) == nil)
    }

    @Test
    func returnsNilWhenInteractionDisabled() {
        let sticker = makeSticker()
        sticker.isUserInteractionEnabled = false
        #expect(sticker.hitTest(CGPoint(x: 55, y: 60), with: nil) == nil)
    }

    @Test
    func returnsContentViewForCenterPoint() {
        let sticker = makeSticker()
        // contentView center sits at (55, 60) in the sticker's coordinate space.
        #expect(sticker.hitTest(CGPoint(x: 55, y: 60), with: nil) === sticker.contentView)
    }

    @Test
    func returnsControlForCornerPoint() {
        let sticker = makeSticker()
        // The left-top (delete) control occupies (0, 0, 30, 30) and is enabled by default.
        #expect(sticker.hitTest(CGPoint(x: 10, y: 10), with: nil) === sticker.leftTopControl)
    }

    @Test
    func returnsNilOutsideContent() {
        let sticker = makeSticker()
        #expect(sticker.hitTest(CGPoint(x: 500, y: 500), with: nil) == nil)
    }
}

// MARK: - Simultaneous recognition

@MainActor
struct IRStickerViewGestureDelegateTests {

    @Test
    func tapNeverRecognizesSimultaneously() {
        let sticker = makeSticker()
        let tap = UITapGestureRecognizer()
        let pinch = UIPinchGestureRecognizer()
        #expect(sticker.gestureRecognizer(tap, shouldRecognizeSimultaneouslyWith: pinch) == false)
        #expect(sticker.gestureRecognizer(pinch, shouldRecognizeSimultaneouslyWith: tap) == false)
    }

    @Test
    func nonTapGesturesRecognizeSimultaneously() {
        let sticker = makeSticker()
        let pinch = UIPinchGestureRecognizer()
        let rotate = UIRotationGestureRecognizer()
        #expect(sticker.gestureRecognizer(pinch, shouldRecognizeSimultaneouslyWith: rotate) == true)
    }

    @Test
    func unrelatedGestureMayBegin() {
        let sticker = makeSticker()
        let tap = UITapGestureRecognizer()
        #expect(sticker.gestureRecognizerShouldBegin(tap))
    }
}

// MARK: - IRStickerGestureRecognizer

@MainActor
struct IRStickerGestureRecognizerTests {

    @Test
    func computesEuclideanDistance() {
        let recognizer = IRStickerGestureRecognizer(target: nil, action: nil)
        let distance = recognizer.distanceBetweenFirstPoint(
            first: CGPoint(x: 0, y: 0),
            secondPoint: CGPoint(x: 3, y: 4)
        )
        #expect(abs(distance - 5.0) < 1e-6)
    }

    @Test
    func resetRestoresIdentityScaleAndRotation() {
        let recognizer = IRStickerGestureRecognizer(target: nil, action: nil)
        recognizer.scale = 2.5
        recognizer.rotation = 1.2
        recognizer.resetGesture()
        #expect(recognizer.scale == 1)
        #expect(recognizer.rotation == 0)
    }
}
