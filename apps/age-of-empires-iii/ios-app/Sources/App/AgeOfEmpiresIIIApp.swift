// Port of Main.java — SwiftUI Entry Point targeting iOS 16.1.1 (iPhone XS Max 414x896 @3x)
#if canImport(UIKit)
import SwiftUI

@main
public struct AgeOfEmpiresIIIApp: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            GameContainerView()
                .preferredColorScheme(.dark)
        }
    }
}
#endif
