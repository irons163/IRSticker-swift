import Testing
import UIKit
@testable import IRSticker_swift

@MainActor
final class IRStickerViewTests {
    @Test
    func performTapOperationCallsDelegate() {
        let image = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { _ in }
        let stickerView = IRStickerView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), contentImage: image)
        let delegate = DelegateProbe()

        stickerView.delegate = delegate
        stickerView.performTapOperation()

        #expect(delegate.didTapContentView)
    }
}

@MainActor
private final class DelegateProbe: NSObject, IRStickerViewDelegate {
    private(set) var didTapContentView = false

    func stickerViewDidTapContentView(stickerView: IRStickerView) {
        didTapContentView = true
    }
}
