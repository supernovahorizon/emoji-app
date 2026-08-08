import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            WelcomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            EnableKeyboardView()
                .tabItem {
                    Label("Enable", systemImage: "keyboard")
                }

            EmojiExplorerView()
                .tabItem {
                    Label("Explore", systemImage: "face.smiling")
                }

            ThemesView()
                .tabItem {
                    Label("Themes", systemImage: "paintpalette")
                }

            MoreView()
                .tabItem {
                    Label("More", systemImage: "ellipsis.circle")
                }
        }
    }
}

#Preview {
    RootTabView()
}
