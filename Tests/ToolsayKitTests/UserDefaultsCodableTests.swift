import Testing
import Foundation
@testable import ToolsayKit

@MainActor
struct UserDefaultsCodableTests {
    private struct TestSettings: UserDefaultsCodable, Equatable {
        var value = 0
    }

    @Test func userDefaultsLoadReturnsDefaultWhenNoData() {
        UserDefaults.standard.removeObject(forKey: "0")
        let loaded = TestSettings.loadFromUserDefaults()
        #expect(loaded == TestSettings())
    }

    @Test func userDefaultsSaveAndLoadRoundTrips() {
        UserDefaults.standard.removeObject(forKey: "0")

        var s = TestSettings()
        s.value = 123
        s.saveToUserDefaults()

        let loaded = TestSettings.loadFromUserDefaults()
        #expect(loaded.value == 123)
    }

    @Test func userDefaultsLoadReturnsDefaultWhenDataCorrupted() {
        UserDefaults.standard.set(Data([0xFF, 0xFF, 0xFF]), forKey: "0")
        let loaded = TestSettings.loadFromUserDefaults()
        #expect(loaded == TestSettings())
    }
}

