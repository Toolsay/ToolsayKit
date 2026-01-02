import SwiftUI

struct SaveOnBackgroundModifier<C: UserDefaultsCodable>: ViewModifier {
	@Environment(\.scenePhase) private var scenePhase
	let codable: C

	func body(content: Content) -> some View {
		content
			.onChange(of: scenePhase) { _, newPhase in
				if newPhase == .background { codable.save() }
			}
	}
}

public extension View {
	/// Saves the specified object when the scene enters the background.
	func saveOnBackground<C: UserDefaultsCodable>(_ codable: C) -> some View {
		modifier(SaveOnBackgroundModifier(codable: codable))
	}
}
