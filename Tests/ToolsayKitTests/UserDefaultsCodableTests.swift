import Testing
import Foundation
@testable import ToolsayKit

@MainActor
struct UserDefaultsCodableTests {
    private final class TestSettings: UserDefaultsCodable {
        var value = 0
        static let defaultsValue = 42

        func loadDefaults() {
            value = Self.defaultsValue
        }
    }

    @Test func userDefaultsLoadReturnsDefaultWhenNoData() {
        UserDefaults.standard.removeObject(forKey: "0")
        let loaded = TestSettings.loadFromUserDefaults()
        #expect(loaded.value == TestSettings.defaultsValue)
    }

    @Test func userDefaultsSaveAndLoadRoundTrips() {
        UserDefaults.standard.removeObject(forKey: "0")

        let s = TestSettings()
        s.value = 123
        s.saveToUserDefaults()

        let loaded = TestSettings.loadFromUserDefaults()
        #expect(loaded.value == 123)
        #expect(loaded.value != TestSettings.defaultsValue)
    }

    @Test func userDefaultsLoadReturnsDefaultWhenDataCorrupted() {
        UserDefaults.standard.set(Data([0xFF, 0xFF, 0xFF]), forKey: "0")
        let loaded = TestSettings.loadFromUserDefaults()
        #expect(loaded.value == TestSettings.defaultsValue)
    }
}

