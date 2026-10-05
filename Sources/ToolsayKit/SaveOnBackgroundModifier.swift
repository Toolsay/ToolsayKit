import SwiftUI

#if os(macOS)
	import AppKit
#endif

struct SaveOnBackgroundModifier<C: UserDefaultsCodable>: ViewModifier {
	@Environment(\.scenePhase) private var scenePhase
	let codable: C

	func body(content: Content) -> some View {
		content
			.onChange(of: scenePhase) { _, newPhase in
				if newPhase == .background { codable.save() }
			}

			// On macOS, the scene phase doesn't change, but onDisappear is called on window closes, including when the app quits.
			// On iOS, when the user closes the app, onDisappear is called and the scene phase changes to background, so we don't subscribe to onDisappear to avoid saving twice.
			#if os(macOS)
				.onDisappear {
					codable.save()
				}
			#endif
	}
}

extension View {
	/// Saves the specified object when the scene enters the background.
	/// On macOS, also saves when the app quits or the view disappears.
	public func saveOnBackground<C: UserDefaultsCodable>(_ codable: C) -> some View {
		modifier(SaveOnBackgroundModifier(codable: codable))
	}
}
