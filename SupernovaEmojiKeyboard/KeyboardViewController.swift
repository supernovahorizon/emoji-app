import UIKit
import SwiftUI

/// Hosts the SwiftUI keyboard and adapts UITextDocumentProxy to TextInputHandling.
final class KeyboardViewController: UIInputViewController {
    private var hostingController: UIHostingController<KeyboardRootView>?
    private var viewModel: KeyboardViewModel?
    private var inputAdapter: ProxyTextInputHandler?
    private var heightConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        setupKeyboard()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateKeyboardHeight()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Keep SwiftUI host glued to the full keyboard bounds (including bottom area).
        hostingController?.view.frame = view.bounds
        updateKeyboardHeight()
    }

    override func textWillChange(_ textInput: UITextInput?) {
        // Intentionally empty — do not inspect or log document content.
    }

    override func textDidChange(_ textInput: UITextInput?) {
        // Intentionally empty — do not inspect or log document content.
    }

    private func setupKeyboard() {
        let adapter = ProxyTextInputHandler(controller: self)
        self.inputAdapter = adapter

        let store = FallbackPreferencesStore(
            primary: LocalPreferencesStore(),
            fallback: InMemoryPreferencesStore()
        )

        let catalog: EmojiCatalog
        let loadFailed: Bool
        do {
            catalog = try EmojiCatalogLoader().loadBundled(in: Bundle(for: KeyboardViewController.self))
            loadFailed = false
        } catch {
            catalog = KeyboardViewController.fallbackCatalog()
            loadFailed = true
        }

        let model = KeyboardViewModel(
            catalog: catalog,
            store: store,
            input: adapter,
            loadFailed: loadFailed,
            initialPanel: .letters
        )
        self.viewModel = model

        let host = UIHostingController(rootView: KeyboardRootView(viewModel: model))
        host.view.backgroundColor = .clear
        host.view.translatesAutoresizingMaskIntoConstraints = false
        // Draw into the home-indicator region so keys can fill the whole plate.
        host.view.insetsLayoutMarginsFromSafeArea = false
        host.safeAreaRegions = []

        addChild(host)
        view.addSubview(host.view)
        NSLayoutConstraint.activate([
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            host.view.topAnchor.constraint(equalTo: view.topAnchor),
            host.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        host.didMove(toParent: self)
        hostingController = host

        // Priority required so the system actually grows the keyboard plate.
        let height = view.heightAnchor.constraint(equalToConstant: Self.targetHeight())
        height.priority = UILayoutPriority(999)
        height.isActive = true
        heightConstraint = height
    }

    private func updateKeyboardHeight() {
        heightConstraint?.constant = Self.targetHeight()
    }

    /// Match a full system-style keyboard footprint (fills the plate; keys scale inside).
    private static func targetHeight() -> CGFloat {
        let screen = UIScreen.main.bounds
        let shortest = min(screen.width, screen.height)
        let longest = max(screen.width, screen.height)
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        if isPad {
            return min(max(longest * 0.28, 300), 380)
        }
        // iPhone: ~38% of short side feels like stock keyboard and removes empty gap.
        return min(max(shortest * 0.42, 280), 340)
    }

    private static func fallbackCatalog() -> EmojiCatalog {
        EmojiCatalog(
            schemaVersion: 1,
            categories: [
                EmojiCategory(id: "smileys", title: "Smileys", symbol: "😊", sortOrder: 1)
            ],
            items: [
                EmojiItem(id: "smile_happy", glyph: "😊", name: "Smiling face", categoryId: "smileys")
            ]
        )
    }
}

/// Production adapter — never logs inserted text.
final class ProxyTextInputHandler: TextInputHandling {
    private weak var controller: UIInputViewController?

    init(controller: UIInputViewController) {
        self.controller = controller
    }

    func insertText(_ text: String) {
        controller?.textDocumentProxy.insertText(text)
    }

    func deleteBackward() {
        controller?.textDocumentProxy.deleteBackward()
    }

    func advanceToNextInputMode() {
        controller?.advanceToNextInputMode()
    }
}
