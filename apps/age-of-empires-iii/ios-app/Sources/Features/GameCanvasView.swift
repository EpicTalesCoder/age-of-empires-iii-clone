// Port of c.java GameCanvas Landscape Viewport (512x250) with Tap Selection & Camera Pan
#if canImport(UIKit)
import SwiftUI
import UIKit

public final class PixelCanvasUIView: UIView {
    public var cgImage: CGImage? {
        didSet {
            layer.contents = cgImage
        }
    }
    public var onTapLogical: ((Int, Int) -> Void)?
    public var onPanDelta: ((Int, Int) -> Void)?

    private var lastPanPoint: CGPoint?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        isMultipleTouchEnabled = false
        backgroundColor = .black
        layer.contentsGravity = .resizeAspect
        layer.magnificationFilter = .nearest
        layer.minificationFilter = .nearest

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tap)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.minimumNumberOfTouches = 1
        pan.maximumNumberOfTouches = 1
        addGestureRecognizer(pan)
    }

    @objc private func handleTap(_ recognizer: UITapGestureRecognizer) {
        let pt = recognizer.location(in: self)
        guard bounds.width > 0, bounds.height > 0 else { return }
        let lx = Int((pt.x / bounds.width) * CGFloat(XSMaxLayout.gameLogicalWidth))
        let ly = Int((pt.y / bounds.height) * CGFloat(XSMaxLayout.gameLogicalHeight))
        onTapLogical?(
            max(0, min(XSMaxLayout.gameLogicalWidth - 1, lx)),
            max(0, min(XSMaxLayout.gameLogicalHeight - 1, ly))
        )
    }

    @objc private func handlePan(_ recognizer: UIPanGestureRecognizer) {
        let pt = recognizer.location(in: self)
        switch recognizer.state {
        case .began:
            lastPanPoint = pt
        case .changed:
            if let prev = lastPanPoint, bounds.width > 0, bounds.height > 0 {
                let scaleX = CGFloat(XSMaxLayout.gameLogicalWidth) / bounds.width
                let scaleY = CGFloat(XSMaxLayout.gameLogicalHeight) / bounds.height
                let dx = Int((prev.x - pt.x) * scaleX)
                let dy = Int((prev.y - pt.y) * scaleY)
                if dx != 0 || dy != 0 {
                    onPanDelta?(dx, dy)
                    lastPanPoint = pt
                }
            }
        default:
            lastPanPoint = nil
        }
    }
}

public struct GameCanvasView: UIViewRepresentable {
    public let frameImage: CGImage?
    public let onTap: (Int, Int) -> Void
    public let onPanDelta: (Int, Int) -> Void

    public init(frameImage: CGImage?, onTap: @escaping (Int, Int) -> Void, onPanDelta: @escaping (Int, Int) -> Void) {
        self.frameImage = frameImage
        self.onTap = onTap
        self.onPanDelta = onPanDelta
    }

    public func makeUIView(context: Context) -> PixelCanvasUIView {
        let view = PixelCanvasUIView(frame: .zero)
        view.onTapLogical = onTap
        view.onPanDelta = onPanDelta
        return view
    }

    public func updateUIView(_ uiView: PixelCanvasUIView, context: Context) {
        uiView.cgImage = frameImage
        uiView.onTapLogical = onTap
        uiView.onPanDelta = onPanDelta
    }
}
#endif
