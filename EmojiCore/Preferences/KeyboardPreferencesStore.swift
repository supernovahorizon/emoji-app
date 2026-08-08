import Foundation

public protocol KeyboardPreferencesStore: Sendable {
    func load() -> KeyboardPreferences
    func save(_ preferences: KeyboardPreferences)
    func reset()
}

/// In-memory store for tests and ephemeral sessions.
public final class InMemoryPreferencesStore: KeyboardPreferencesStore, @unchecked Sendable {
    private let lock = NSLock()
    private var value: KeyboardPreferences

    public init(initial: KeyboardPreferences = KeyboardPreferences()) {
        self.value = initial
    }

    public func load() -> KeyboardPreferences {
        lock.lock(); defer { lock.unlock() }
        return value
    }

    public func save(_ preferences: KeyboardPreferences) {
        lock.lock(); defer { lock.unlock() }
        value = preferences
    }

    public func reset() {
        lock.lock(); defer { lock.unlock() }
        value = KeyboardPreferences()
    }
}

/// UserDefaults-backed store. Uses standard suite unless a suite name is provided (App Group optional).
public final class LocalPreferencesStore: KeyboardPreferencesStore, @unchecked Sendable {
    public static let defaultsKey = "supernova.emoji.keyboard.preferences"

    private let defaults: UserDefaults
    private let key: String
    private let lock = NSLock()

    public init(suiteName: String? = nil, key: String = LocalPreferencesStore.defaultsKey) {
        if let suiteName, let suite = UserDefaults(suiteName: suiteName) {
            self.defaults = suite
        } else {
            self.defaults = .standard
        }
        self.key = key
    }

    public func load() -> KeyboardPreferences {
        lock.lock(); defer { lock.unlock() }
        guard let data = defaults.data(forKey: key) else {
            return KeyboardPreferences()
        }
        do {
            return try JSONDecoder().decode(KeyboardPreferences.self, from: data)
        } catch {
            return KeyboardPreferences()
        }
    }

    public func save(_ preferences: KeyboardPreferences) {
        lock.lock(); defer { lock.unlock() }
        do {
            let data = try JSONEncoder().encode(preferences)
            defaults.set(data, forKey: key)
        } catch {
            // Prefer not crashing the keyboard; keep last good state.
        }
    }

    public func reset() {
        lock.lock(); defer { lock.unlock() }
        defaults.removeObject(forKey: key)
    }
}

/// Tries primary store; falls back if load/save fails conceptually via empty load.
public final class FallbackPreferencesStore: KeyboardPreferencesStore, @unchecked Sendable {
    private let primary: any KeyboardPreferencesStore
    private let fallback: any KeyboardPreferencesStore
    private let lock = NSLock()
    private var useFallback = false

    public init(primary: any KeyboardPreferencesStore, fallback: any KeyboardPreferencesStore) {
        self.primary = primary
        self.fallback = fallback
    }

    public func load() -> KeyboardPreferences {
        lock.lock(); defer { lock.unlock() }
        if useFallback {
            return fallback.load()
        }
        return primary.load()
    }

    public func save(_ preferences: KeyboardPreferences) {
        lock.lock(); defer { lock.unlock() }
        if useFallback {
            fallback.save(preferences)
            return
        }
        primary.save(preferences)
    }

    public func reset() {
        lock.lock(); defer { lock.unlock() }
        primary.reset()
        fallback.reset()
        useFallback = false
    }

    /// Test/support hook to force fallback path.
    public func forceFallback(_ enabled: Bool) {
        lock.lock(); defer { lock.unlock() }
        useFallback = enabled
    }
}
