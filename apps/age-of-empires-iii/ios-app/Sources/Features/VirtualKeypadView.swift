// Port of c.a[14][5] virtual keypad overlay (touch.png 360x241 + LSK/RSK controls)
#if canImport(UIKit)
import SwiftUI
import UIKit

public struct VirtualKeypadView: View {
    public let touchUIImage: UIImage?
    public let onTouchXY: (Int, Int) -> Void
    public let onKeyCode: (Int) -> Void

    public init(touchUIImage: UIImage?, onTouchXY: @escaping (Int, Int) -> Void, onKeyCode: @escaping (Int) -> Void) {
        self.touchUIImage = touchUIImage
        self.onTouchXY = onTouchXY
        self.onKeyCode = onKeyCode
    }

    public var body: some View {
        VStack(spacing: 6) {
            // Softkey + Action strip aligned with J2ME softkeys (-6 LSK / 5 FIRE / -7 RSK)
            HStack(spacing: 10) {
                softButton(title: "LSK / Chon", code: -6)
                softButton(title: "FIRE (5)", code: -5)
                softButton(title: "RSK / Menu", code: -7)
            }
            .padding(.horizontal, 12)

            // Original 360x241 touch.png phone keypad overlay with exact c.a hitbox mapping
            GeometryReader { geo in
                ZStack {
                    if let img = touchUIImage {
                        Image(uiImage: img)
                            .resizable()
                            .interpolation(.none)
                            .frame(width: geo.size.width, height: geo.size.height)
                    } else {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(red: 0.12, green: 0.09, blue: 0.06))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(red: 0.62, green: 0.49, blue: 0.27), lineWidth: 1)
                            )
                    }
                }
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onEnded { value in
                            guard geo.size.width > 0, geo.size.height > 0 else { return }
                            let lx = Int((value.location.x / geo.size.width) * CGFloat(XSMaxLayout.keypadImageWidth))
                            let ly = Int((value.location.y / geo.size.height) * CGFloat(XSMaxLayout.keypadImageHeight))
                            onTouchXY(
                                max(0, min(XSMaxLayout.keypadImageWidth, lx)),
                                max(0, min(XSMaxLayout.keypadImageHeight, ly))
                            )
                        }
                )
            }
            .aspectRatio(
                CGFloat(XSMaxLayout.keypadImageWidth) / CGFloat(XSMaxLayout.keypadImageHeight),
                contentMode: .fit
            )
            .frame(maxWidth: .infinity)
        }
    }

    private func softButton(title: String, code: Int) -> some View {
        Button(action: { onKeyCode(code) }) {
            Text(title)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundColor(Color(red: 0.96, green: 0.87, blue: 0.62))
                .frame(maxWidth: .infinity, minHeight: 34)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(red: 0.17, green: 0.12, blue: 0.07))
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color(red: 0.65, green: 0.51, blue: 0.25), lineWidth: 1)
                        )
                )
        }
        .buttonStyle(.plain)
    }
}
#endif
