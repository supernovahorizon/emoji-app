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
        applyBoardHeight()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.applyBoardHeight()
        })
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

        let stickers: KatseyeStickerCatalog
        do {
            stickers = try KatseyeStickerCatalog.loadBundled(in: Bundle(for: KeyboardViewController.self))
        } catch {
            stickers = KatseyeStickerCatalog(stickers: [])
        }

        let model = KeyboardViewModel(
            catalog: catalog,
            store: store,
            input: adapter,
            loadFailed: loadFailed,
            initialPanel: .letters,
            stickerCatalog: stickers
        )
        self.viewModel = model

        let host = UIHostingController(rootView: KeyboardRootView(viewModel: model))
        host.view.backgroundColor = .clear
        host.view.translatesAutoresizingMaskIntoConstraints = false
        host.view.insetsLayoutMarginsFromSafeArea = false
        host.safeAreaRegions = []

        addChild(host)
        view.addSubview(host.view)
        // Auto Layout only — do NOT also assign host.view.frame (that fights constraints
        // and can inflate the plate / make keys look zoomed).
        NSLayoutConstraint.activate([
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            host.view.topAnchor.constraint(equalTo: view.topAnchor),
            host.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        host.didMove(toParent: self)
        hostingController = host

        // Required priority so the system respects our plate size.
        let height = view.heightAnchor.constraint(equalToConstant: KeyboardMetrics.boardHeightForMainScreen())
        height.priority = .required
        height.isActive = true
        heightConstraint = height
    }

    private func applyBoardHeight() {
        let target = KeyboardMetrics.boardHeightForMainScreen()
        #if DEBUG
        if let issue = KeyboardMetrics.validateBoardHeight(
            target,
            isPad: UIDevice.current.userInterfaceIdiom == .pad
        ) {
            assertionFailure("Keyboard height regression: \(issue)")
        }
        #endif
        guard heightConstraint?.constant != target else { return }
        heightConstraint?.constant = target
        view.setNeedsLayout()
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

    func copyImageData(_ data: Data, uti: String) {
        // Best-effort sticker copy. Host apps that accept paste will get the image.
        // Does not log content. Full Access is not required to set the pasteboard
        // from a keyboard in current iOS, but some hosts still only accept text.
        UIPasteboard.general.setData(data, forPasteboardType: uti)
        if let image = UIImage(data: data) {
            UIPasteboard.general.image = image
        }
    }
}
