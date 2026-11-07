import SwiftUI

struct RootView: View {
    private enum Stage {
        case splash
        case login
        case catalog
    }

    @State private var stage: Stage = .splash

    var body: some View {
        ZStack {
            switch stage {
            case .splash:
                SplashScreen { stage = .login }
                    .transition(.opacity)
            case .login:
                LoginScreen { stage = .catalog }
                    .transition(.opacity)
            case .catalog:
                ContentView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.35), value: stage)
    }
}

#Preview {
    RootView()
        .environment(CatalogStore())
        .preferredColorScheme(.dark)
}
