// Evidence: ios-rebuild-fidelity.md & ARCHITECTURE-MAP.md — iPhone XS Max Landscape (896x414 pt @3x) Safe Area Geometry
import CoreGraphics

public enum XSMaxLayout {
    // Locked target device: iPhone XS Max rotated to Landscape (896 x 414 pt @3x)
    // Safe areas in Landscape: Top = 0 pt, Bottom Home Indicator = 21 pt, Left/Right Notch = 44 pt -> playable = 808 x 393 pt
    public static let deviceLandscapeWidth: CGFloat = 896.0
    public static let deviceLandscapeHeight: CGFloat = 414.0
    public static let scaleFactor: CGFloat = 3.0
    public static let sideSafeAreaLandscape: CGFloat = 44.0
    public static let bottomSafeAreaLandscape: CGFloat = 21.0
    public static let safePlayableWidth: CGFloat = 808.0
    public static let safePlayableHeight: CGFloat = 393.0

    // Widescreen logical canvas matching ~808:393 aspect ratio (2.048:1) for crisp pixel-art RTS gameplay in Landscape only
    public static let gameLogicalWidth: Int = 512
    public static let gameLogicalHeight: Int = 250
    public static let topBarHeight: Int = 20
    public static let bottomBarHeight: Int = 44
    public static let playfieldBottomY: Int = 206 // gameLogicalHeight - bottomBarHeight
}
