import UIKit
import SwiftUI

/// Hosts the SwiftUI keyboard and adapts UITextDocumentProxy to TextInputHandling.
final class KeyboardViewController: UIInputViewController {
    private var hostingController: UIHostingController<KeyboardRootView>?
    private var viewModel: KeyboardViewModel?
    private var inputAdapter: ProxyTextInputHandler?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        setupKeyboard()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        hostingController?.view.frame = view.bounds
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
            loadFailed: loadFailed
        )
        self.viewModel = model

        let root = KeyboardRootView(viewModel: model)
        let host = UIHostingController(rootView: root)
        host.view.backgroundColor = .clear
        host.view.translatesAutoresizingMaskIntoConstraints = false

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
