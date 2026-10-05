/// An integer key for encoding and decoding. The key can be any `Unicode.Scalar`.
/// The string value for the key is a single-character string whose character is the integer key.
/// Useful for speed and decoupling persistence from property names.
public struct IntCodingKey: CodingKey {
	public let intValue: Int?
	public let stringValue: String

	public init?(intValue: Int) {
		guard let value = UInt32(exactly: intValue), let scalar = UnicodeScalar(value) else { return nil }
		self.intValue = intValue
		stringValue = String(scalar)
	}

	public init?(stringValue: String) {
		guard let scalar = stringValue.unicodeScalars.first else { return nil }
		intValue = Int(scalar.value)
		self.stringValue = String(scalar)
	}
}

extension KeyedDecodingContainer<IntCodingKey> {
	public func decode<T>(_ type: T.Type, forKey key: Int) throws -> T where T: Decodable {
		guard let codingKey = IntCodingKey(intValue: key) else {
			throw invalidKeyError(key)
		}
		return try decode(type, forKey: codingKey)
	}

	public func decodeIfPresent<T>(_ type: T.Type, forKey key: Int) throws -> T? where T: Decodable {
		guard let codingKey = IntCodingKey(intValue: key) else {
			throw invalidKeyError(key)
		}
		return try decodeIfPresent(type, forKey: codingKey)
	}

	private func invalidKeyError(_ key: Int) -> DecodingError {
		DecodingError.dataCorrupted(.init(codingPath: codingPath, debugDescription: "Key: \(key)"))
	}
}

extension KeyedEncodingContainer<IntCodingKey> {
	public mutating func encode<T>(_ value: T, forKey key: Int) throws where T: Encodable {
		guard let codingKey = IntCodingKey(intValue: key) else {
			throw invalidKeyError(key)
		}
		try encode(value, forKey: codingKey)
	}

	public mutating func encodeIfPresent<T>(_ value: T?, forKey key: Int) throws where T: Encodable {
		guard let codingKey = IntCodingKey(intValue: key) else {
			throw invalidKeyError(key)
		}
		try encodeIfPresent(value, forKey: codingKey)
	}

	private func invalidKeyError(_ key: Int) -> EncodingError {
		EncodingError.invalidValue(key, .init(codingPath: codingPath, debugDescription: "Key: \(key)"))
	}
}
