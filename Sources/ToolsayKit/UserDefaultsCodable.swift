import Foundation

/// A type that can read or write itself from or to a default binary property list in user defaults.
public protocol UserDefaultsCodable: Codable {
	init()

	/// Initializes default values when the type cannot be deserialized.
	func initDefaults()

	/// Called when the load (or default initialize if load failed) completes.
	func didLoad()

	/// Called when the save attempt completes.
	func didSave()
}

public extension UserDefaultsCodable {
	/// Reads from user defaults. Falls back to default initialization on failure.
	static func load() -> Self {
		var instance: Self
		if let data = UserDefaults.standard.data(forKey: "0"), let loaded = try? PropertyListDecoder().decode(Self.self, from: data) {
			instance = loaded
		} else {
			instance = Self()
			instance.initDefaults()
		}
		instance.didLoad()
		return instance
	}

	/// Writes to user defaults. Writing can be delayed and may not complete if the app is terminated via the debugger.
	func save() {
		try? UserDefaults.standard.set(PropertyListEncoder().encode(self), forKey: "0")
		didSave()
	}

	func initDefaults() {}
	func didLoad() {}
	func didSave() {}
}
