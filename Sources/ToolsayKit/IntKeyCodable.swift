// Not defining IntKeyCodable because it doesn't prevent Swift from synthesizing serializers for Codable types. The type needs to define the coding methods directly.
#if false
/// A type that can convert itself into and out of an external representation encoded using a container appropriate for holding multiple values keyed by integers.
public protocol IntKeyCodable: Codable {
	init(container: KeyedDecodingContainer<IntCodingKey>) throws
	func encode(container: inout KeyedEncodingContainer<IntCodingKey>) throws
}

public extension IntKeyCodable {
	init(from decoder: any Decoder) throws {
		try self.init(container: decoder.container(keyedBy: IntCodingKey.self))
	}

	func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: IntCodingKey.self)
		try encode(container: &container)
	}
}
#endif
