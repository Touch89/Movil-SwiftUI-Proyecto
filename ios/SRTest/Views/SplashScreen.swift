import SwiftUI

struct SplashScreen: View {
    let onFinish: () -> Void

    @State private var isVisible = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(spacing: 20) {
            AppLogo(size: 132)

            Text(verbatim: "SRTest")
                .font(.system(size: 28, weight: .bold))
                .tracking(-0.9)
                .foregroundStyle(Theme.textPrimary)
        }
        .opacity(isVisible ? 1 : 0)
        .scaleEffect(isVisible || reduceMotion ? 1 : 0.86)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppBackground())
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                isVisible = true
            }
        }
        .task {
            try? await Task.sleep(for: .seconds(1.8))
            guard !Task.isCancelled else { return }
            onFinish()
        }
    }
}
