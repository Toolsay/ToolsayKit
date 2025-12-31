/// An integer key for encoding and decoding. The key can be any `Unicode.Scalar`.
/// The string value for the key is a single-character string whose character is the integer key.
/// Useful for speed and decoupling persistence from property names.
public struct IntCodingKey: CodingKey {
	public var intValue: Int?
	public var stringValue: String {
		guard let intValue else { return "" }
		return String(UnicodeScalar(UInt8(intValue)))
	}

	public init?(intValue: Int) { self.intValue = intValue }
	public init?(stringValue: String) {
		guard let value = stringValue.unicodeScalars.first?.value else { return nil }
		intValue = Int(value)
	}
}

public extension KeyedDecodingContainer<IntCodingKey> {
	func decode<T>(_ type: T.Type, forKey key: Int) throws -> T where T: Decodable { try decode(type, forKey: .init(intValue: key)!) }
	func decodeIfPresent<T>(	_ type: T.Type,	forKey key: Int) throws -> T? where T : Decodable  { try decodeIfPresent(type, forKey: .init(intValue: key)!) }
}

public extension KeyedEncodingContainer<IntCodingKey> {
	mutating func encode<T>(_ value: T, forKey key: Int) throws where T: Encodable { try encode(value, forKey: .init(intValue: key)!) }
	mutating func encodeIfPresent<T>(_ value: T?, forKey key: Int) throws where T: Encodable { try encodeIfPresent(value, forKey: .init(intValue: key)!) }
}
