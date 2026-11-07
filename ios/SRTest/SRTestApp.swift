import SwiftUI

@main
struct SRTestApp: App {
    @State private var store = CatalogStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(store)
                .preferredColorScheme(.dark)
        }
    }
}
