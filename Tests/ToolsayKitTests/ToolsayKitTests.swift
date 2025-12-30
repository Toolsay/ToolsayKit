import Testing
import Foundation
@testable import ToolsayKit

// MARK: - IntCodingKey Initialization Tests

@Test func intCodingKeyInitWithInt() {
    let key = IntCodingKey(intValue: 65)
    #expect(key != nil)
    #expect(key?.intValue == 65)
}

@Test func intCodingKeyInitWithString() {
    let key = IntCodingKey(stringValue: "A")
    #expect(key != nil)
    #expect(key?.intValue == 65) // 'A' has ASCII value 65
}

@Test func intCodingKeyInitWithEmptyStringReturnsNil() {
    let key = IntCodingKey(stringValue: "")
    #expect(key == nil)
}

@Test func intCodingKeyStringValue() {
    let key = IntCodingKey(intValue: 66)! // 'B'
    #expect(key.stringValue == "B")
}

@Test func intCodingKeyStringValueWithNilIntValue() {
    // Test the empty string case when intValue is nil
    // This shouldn't happen in normal usage, but tests the guard clause
    let key = IntCodingKey(stringValue: "X")
    #expect(key != nil)
    #expect(key?.stringValue == "X")
}

// MARK: - Roundtrip Tests

@Test func intCodingKeyRoundtripFromInt() {
    let original = 72 // 'H'
    let key = IntCodingKey(intValue: original)!
    let reconstructed = IntCodingKey(stringValue: key.stringValue)!
    #expect(reconstructed.intValue == original)
}

@Test func intCodingKeyRoundtripFromString() {
    let original = "Z"
    let key = IntCodingKey(stringValue: original)!
    #expect(key.stringValue == original)
}

// MARK: - Encoding/Decoding Container Extension Tests

struct TestStruct: Codable, Equatable {
    let name: String
    let age: Int
    let nickname: String?
    
    enum Keys: Int {
        case name = 1
        case age = 2
        case nickname = 3
    }
    
    init(name: String, age: Int, nickname: String? = nil) {
        self.name = name
        self.age = age
        self.nickname = nickname
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: IntCodingKey.self)
        name = try container.decode(String.self, forKey: Keys.name.rawValue)
        age = try container.decode(Int.self, forKey: Keys.age.rawValue)
        nickname = try container.decodeIfPresent(String.self, forKey: Keys.nickname.rawValue)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: IntCodingKey.self)
        try container.encode(name, forKey: Keys.name.rawValue)
        try container.encode(age, forKey: Keys.age.rawValue)
        try container.encodeIfPresent(nickname, forKey: Keys.nickname.rawValue)
    }
}

@Test func encodeAndDecodeWithIntCodingKey() throws {
    let original = TestStruct(name: "Alice", age: 30, nickname: "Ali")
    
    let encoder = JSONEncoder()
    let data = try encoder.encode(original)
    
    let decoder = JSONDecoder()
    let decoded = try decoder.decode(TestStruct.self, from: data)
    
    #expect(decoded == original)
}

@Test func encodeAndDecodeWithNilOptional() throws {
    let original = TestStruct(name: "Bob", age: 25, nickname: nil)
    
    let encoder = JSONEncoder()
    let data = try encoder.encode(original)
    
    let decoder = JSONDecoder()
    let decoded = try decoder.decode(TestStruct.self, from: data)
    
    #expect(decoded == original)
    #expect(decoded.nickname == nil)
}

@Test func encodedKeysAreIntegerBased() throws {
    let value = TestStruct(name: "Test", age: 1)
    
    let encoder = JSONEncoder()
    let data = try encoder.encode(value)
    let jsonString = String(data: data, encoding: .utf8)!
    
    // Keys should be single-character strings based on ASCII values
    // Key 1 = ASCII 1 (SOH control character)
    // Key 2 = ASCII 2 (STX control character)
    // The JSON should NOT contain "name" or "age" as keys
    #expect(!jsonString.contains("\"name\""))
    #expect(!jsonString.contains("\"age\""))
}

// MARK: - Edge Cases

@Test func intCodingKeyWithVariousASCIIValues() {
    let testCases: [(Int, String)] = [
        (48, "0"),  // digit 0
        (57, "9"),  // digit 9
        (97, "a"),  // lowercase a
        (122, "z"), // lowercase z
        (65, "A"),  // uppercase A
        (90, "Z"),  // uppercase Z
    ]
    
    for (intValue, expectedString) in testCases {
        let key = IntCodingKey(intValue: intValue)!
        #expect(key.stringValue == expectedString, "Expected \(expectedString) for int \(intValue)")
    }
}

@Test func intCodingKeyMultiCharacterStringUsesFirst() {
    let key = IntCodingKey(stringValue: "ABC")
    #expect(key != nil)
    #expect(key?.intValue == 65) // Uses first character 'A'
}
