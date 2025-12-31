import Foundation

/// A type that can read or write itself from or to a default binary property list in user defaults.
public protocol UserDefaultsCodable: Codable {
	init()
}

public extension UserDefaultsCodable {
	/// Reads from user defaults. Falls back to default initialization on failure.
	static func loadFromUserDefaults() -> Self {
		(try? PropertyListDecoder().decode(Self.self, from: UserDefaults.standard.data(forKey: "0") ?? .init())) ?? Self()
	}

	/// Writes to user defaults. Writing can be delayed and may not complete if the app is terminated via the debugger.
	func saveToUserDefaults() {
		try? UserDefaults.standard.set(PropertyListEncoder().encode(self), forKey: "0")
	}
}
