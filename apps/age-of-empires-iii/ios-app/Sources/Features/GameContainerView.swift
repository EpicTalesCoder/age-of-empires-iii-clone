// Port of Main.java & f.java 50ms ObservableObject Coordinator for iOS 16.0+ / iPhone XS Max Landscape (896x414 @3x)
#if canImport(UIKit)
import Combine
import SwiftUI
import UIKit

public final class GameSessionViewModel: ObservableObject {
    @Published public private(set) var currentFrame: CGImage?
    @Published public private(set) var loadError: String?

    private var coordinator: MenuCoordinator?
    private var tickCancellable: AnyCancellable?
    private let haptic = UIImpactFeedbackGenerator(style: .light)

    public init() {
        do {
            let coord = try MenuCoordinator(assets: .shared)
            coord.onHapticPulse = { [weak self] in
                self?.haptic.prepare()
                self?.haptic.impactOccurred()
            }
            self.coordinator = coord
            self.currentFrame = coord.renderFrame().makeCGImage()
            startLoop()
        } catch {
            self.loadError = "Resource init error: \(error.localizedDescription)"
        }
    }

    private func startLoop() {
        tickCancellable?.cancel()
        tickCancellable = Timer.publish(every: 0.05, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self, let coord = self.coordinator else { return }
                coord.tick50ms()
                self.currentFrame = coord.renderFrame().makeCGImage()
            }
    }

    public func handleLifecycle(active: Bool) {
        coordinator?.audio.setLifecyclePaused(!active)
    }

    public func handleCanvasTap(x: Int, y: Int) {
        coordinator?.handleCanvasTap(x: x, y: y)
        refreshNow()
    }

    public func handlePanDelta(dx: Int, dy: Int) {
        guard let coord = coordinator else { return }
        if coord.screenState == .playing {
            coord.engine.cameraIsoX += dx
            coord.engine.cameraIsoY += dy
            coord.engine.clampCamera()
        } else {
            coord.handleMenuScroll(deltaY: dy)
        }
        refreshNow()
    }

    private func refreshNow() {
        if let coord = coordinator {
            currentFrame = coord.renderFrame().makeCGImage()
        }
    }
}

public struct GameContainerView: View {
    @StateObject private var viewModel = GameSessionViewModel()
    @Environment(\.scenePhase) private var scenePhase

    public init() {}

    public var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if let err = viewModel.loadError {
                Text(err)
                    .foregroundColor(.red)
                    .padding()
            } else {
                // Fits 512x250 widescreen cleanly inside iPhone XS Max Landscape safe area (Left/Right 44pt, Bottom 21pt)
                GameCanvasView(
                    frameImage: viewModel.currentFrame,
                    onTap: { x, y in viewModel.handleCanvasTap(x: x, y: y) },
                    onPanDelta: { dx, dy in viewModel.handlePanDelta(dx: dx, dy: dy) }
                )
                .aspectRatio(
                    CGFloat(XSMaxLayout.gameLogicalWidth) / CGFloat(XSMaxLayout.gameLogicalHeight),
                    contentMode: .fit
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        // Strictly iOS 16-safe 1-parameter onChange (never 2-arg iOS 17 overload)
        .onChange(of: scenePhase) { newPhase in
            viewModel.handleLifecycle(active: newPhase == .active)
        }
        .statusBarHidden(true)
    }
}
#endif
