// Evidence: ios-rebuild-fidelity.md & ARCHITECTURE-MAP.md — iPhone XS Max (414x896 @3x) Safe Area Geometry
import CoreGraphics

public enum XSMaxLayout {
    public static let deviceLogicalWidth: CGFloat = 414.0
    public static let deviceLogicalHeight: CGFloat = 896.0
    public static let scaleFactor: CGFloat = 3.0
    public static let topSafeAreaPortrait: CGFloat = 44.0
    public static let bottomSafeAreaPortrait: CGFloat = 34.0

    // Evidence: c.<clinit>() (c.a = 360, c.b = 400) & c.paint() touch.png (360x241 at y=400)
    public static let gameLogicalWidth: Int = 360
    public static let gameLogicalHeight: Int = 400
    public static let keypadImageWidth: Int = 360
    public static let keypadImageHeight: Int = 241
    public static let totalOriginalHeight: Int = 640
}
