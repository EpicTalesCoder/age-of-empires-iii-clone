// Port of Main.java & f.java 50ms ObservableObject Coordinator for iOS 16.0+ / iPhone XS Max (414x896 @3x)
#if canImport(UIKit)
import Combine
import SwiftUI
import UIKit

public final class GameSessionViewModel: ObservableObject {
    @Published public private(set) var currentFrame: CGImage?
    @Published public private(set) var loadError: String?

    public let touchUIImage: UIImage?
    private var coordinator: MenuCoordinator?
    private var tickCancellable: AnyCancellable?
    private let haptic = UIImpactFeedbackGenerator(style: .light)

    public init() {
        if let rawTouch = GameAssets.shared.loadRawFile(named: "touch.png") {
            self.touchUIImage = UIImage(data: rawTouch)
        } else {
            self.touchUIImage = nil
        }

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
        // 50ms pacing matching original f.run() 20 Hz simulation tick
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

    public func handleCameraPan(dx: Int, dy: Int) {
        guard let coord = coordinator, coord.screenState == .playing else { return }
        coord.engine.cameraIsoX += dx
        coord.engine.cameraIsoY += dy
        refreshNow()
    }

    public func handleKeypadTouch(x: Int, y: Int) {
        coordinator?.handleKeypadTouch(xInKeypadArea: x, yInKeypadArea: y)
        refreshNow()
    }

    public func handleKeyCode(_ code: Int) {
        if coordinator?.settings.vibrationEnabled == true {
            haptic.impactOccurred()
        }
        coordinator?.handleKeyCode(code)
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

            VStack(spacing: 8) {
                if let err = viewModel.loadError {
                    Text(err)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    GameCanvasView(
                        frameImage: viewModel.currentFrame,
                        onTap: { x, y in viewModel.handleCanvasTap(x: x, y: y) },
                        onPanDelta: { dx, dy in viewModel.handleCameraPan(dx: dx, dy: dy) }
                    )
                    .aspectRatio(
                        CGFloat(XSMaxLayout.gameLogicalWidth) / CGFloat(XSMaxLayout.gameLogicalHeight),
                        contentMode: .fit
                    )
                    .frame(maxWidth: .infinity)
                }

                VirtualKeypadView(
                    touchUIImage: viewModel.touchUIImage,
                    onTouchXY: { x, y in viewModel.handleKeypadTouch(x: x, y: y) },
                    onKeyCode: { code in viewModel.handleKeyCode(code) }
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 4)
        }
        // Strictly iOS 16-safe 1-parameter onChange (never 2-arg iOS 17 overload)
        .onChange(of: scenePhase) { newPhase in
            viewModel.handleLifecycle(active: newPhase == .active)
        }
    }
}
#endif
