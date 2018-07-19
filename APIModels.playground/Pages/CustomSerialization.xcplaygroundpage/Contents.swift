//: [Previous](@previous)

import Foundation

typealias Identifier = NilOr<Either<String,Int>>


enum StringOrInt: Decodable {
    case int(Int)
    case string(String)
    
    init(from decoder: Decoder) throws {
        if let int = try? decoder.singleValueContainer().decode(Int.self) {
            self = .int(int)
            return
        }
        
        if let string = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(string)
            return
        }
        
        throw DecodingError.valueNotFound(StringOrInt.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "expected String or integer", underlyingError: nil))
    }
    
    var toString: String {
        switch self {
        case .string(let value): return value
        case .int(let int): return "\(int)"
        }
    }
}

enum Either<Left, Right> {
    case left(Left)
    case right(Right)
}

// see if swift 4.2 can synthesize this automatically?
extension Either: Decodable where Left: Decodable, Right: Decodable {
    init(from decoder: Decoder) throws {
        if let left = try? decoder.singleValueContainer().decode(Left.self) {
            self = .left(left)
            return
        }
        
        if let right = try? decoder.singleValueContainer().decode(Right.self) {
            self = .right(right)
            return
        }
        
        throw DecodingError.valueNotFound(Either.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "expected \(Left.self) or \(Right.self)", underlyingError: nil))
    }
}

public struct ValueOrArray<T: Decodable>: Decodable {
    public let value: [T]
    
    public init(from decoder: Decoder) throws {
        if let value = try? decoder.singleValueContainer().decode(T.self) {
            self.value = [value]
        } else if let array = try? decoder.singleValueContainer().decode([T].self) {
            self.value = array
        }
        
        throw DecodingError.valueNotFound(ValueOrArray.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "expected \(T.self) or [\(T.self)]", underlyingError: nil))
    }
}

// if field cannot be decoded into type T, then assumes field is nil
public struct NilOr<T: Decodable>: Decodable {
    public let value: T?
    public init(from decoder: Decoder) throws {
        self.value = try? decoder.singleValueContainer().decode(T.self)
    }
}


//: [Next](@next)
