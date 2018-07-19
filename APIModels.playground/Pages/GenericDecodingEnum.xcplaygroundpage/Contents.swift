//: [Previous](@previous)
import Foundation

// generic DecodingEnum an enum

protocol EnumDecodingInfo {
    associatedtype TypeEnum: RawRepresentable & Decodable where TypeEnum.RawValue == String
    associatedtype AssociatedTypeEnum
    
    static func associatedType(for type: TypeEnum) -> Decodable.Type
    static func associatedTypeEnum(for other: DecodingEnum<Self>) -> AssociatedTypeEnum
}

struct DecodingEnum<Info: EnumDecodingInfo>: Decodable {
    typealias TypeEnum = Info.TypeEnum
    var type: TypeEnum
    var anyValue: Decodable
    
    func value<T: Decodable>() -> T {
        return anyValue as! T
    }
    
    var enumValue: Info.AssociatedTypeEnum {
        return Info.associatedTypeEnum(for: self)
    }
    
    enum CodingKeys: String, CodingKey {
        case type
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            self.type = try container.decode(TypeEnum.self, forKey: CodingKeys.type)
        } catch {
            throw error
        }
        
        let dataType = Info.associatedType(for: type)
        self.anyValue = try dataType.init(from: decoder)
    }
}

// example code

struct MyDecodingInfo: EnumDecodingInfo {
    static func associatedType(for type: DataTypeString) -> Decodable.Type {
        switch type {
        case .image:   return DataImage.self
        case .video:   return DataVideo.self
        case .article: return DataArticle.self
        case .opinion: return DataOpinion.self
        }
    }
    
    static func associatedTypeEnum(for other: DecodingEnum<MyDecodingInfo>) -> AssociatedDataTypeEnum {
        switch other.type {
        case .image:   return .image(other.value())
        case .video:   return .video(other.value())
        case .article: return .article(other.value())
        case .opinion: return .opinion(other.value())
        }
    }
}

typealias MyDecodedEnum = DecodingEnum<MyDecodingInfo>

let jsonData = arrayOfDataObjectsString().data(using: .utf8)!
let apiResponse = try JSONDecoder().decode([MyDecodedEnum].self, from: jsonData).map { $0.enumValue }

for response in apiResponse {
    print("response: \(response)")
}

//: [Next](@next)
