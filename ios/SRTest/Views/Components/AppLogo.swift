import SwiftUI

/// Para cambiar el logotipo, sustituye `Assets.xcassets/AppLogo.imageset/logo.png`.
struct AppLogo: View {
    let size: CGFloat

    var body: some View {
        Image("AppLogo")
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .accessibilityLabel("Logotipo de SRTest")
    }
}
