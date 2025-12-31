import Foundation

/// A type that can read or write itself from or to a default binary property list in user defaults.
public protocol UserDefaultsCodable: Codable {
	init()

	/// Loads default values. Called when the type cannot be deserialized.
	func loadDefaults()
}

public extension UserDefaultsCodable {
	/// Reads from user defaults. Falls back to default initialization on failure.
	static func loadFromUserDefaults() -> Self {
		guard let data = UserDefaults.standard.data(forKey: "0"), let value = try? PropertyListDecoder().decode(Self.self, from: data) else {
			let value = Self.init()
			value.loadDefaults()
			return value
		}
		return value
	}

	/// Writes to user defaults. Writing can be delayed and may not complete if the app is terminated via the debugger.
	func saveToUserDefaults() {
		try? UserDefaults.standard.set(PropertyListEncoder().encode(self), forKey: "0")
	}
}
