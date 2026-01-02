import Foundation

/// A type that can read or write itself from or to a default binary property list in user defaults.
public protocol UserDefaultsCodable: Codable {
	init()

	/// Initializes default values when the type cannot be deserialized.
	func initDefaults()
}

public extension UserDefaultsCodable {
	func initDefaults() {}

	/// Reads from user defaults. Falls back to default initialization on failure.
	static func load() -> Self {
		guard let data = UserDefaults.standard.data(forKey: "0"), let value = try? PropertyListDecoder().decode(Self.self, from: data) else {
			let value = Self()
			value.initDefaults()
			return value
		}
		return value
	}

	/// Writes to user defaults. Writing can be delayed and may not complete if the app is terminated via the debugger.
	func save() {
		try? UserDefaults.standard.set(PropertyListEncoder().encode(self), forKey: "0")
	}
}
