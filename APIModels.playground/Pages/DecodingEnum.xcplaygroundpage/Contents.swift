//: [Previous](@previous)

import Foundation

/*
 This is my first draft of the more generic DecodingEnum,
 focusing on decoding one specific type first.
 */


class MyDecodedEnum: Decodable {
    static let cases: [DataTypeString: Decodable.Type] = [
        .image:   DataImage.self,
        .video:   DataVideo.self,
        .article: DataArticle.self,
        .opinion: DataOpinion.self
    ]
    
    let type: DataTypeString
    let anyValue: Decodable
    
    func value<T: Decodable>() -> T {
        return anyValue as! T
    }
    
    enum CodingKeys: String, CodingKey {
        case type
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            self.type = try container.decode(DataTypeString.self, forKey: .type)
        } catch {
            throw error
        }
        
        let dataType = MyDecodedEnum.cases[type]!
        self.anyValue = try dataType.init(from: decoder)
    }
}

extension AssociatedDataTypeEnum {
    init(other: MyDecodedEnum) {
        switch other.type {
        case .image:   self = .image(other.value())
        case .video:   self = .video(other.value())
        case .article: self = .article(other.value())
        case .opinion: self = .opinion(other.value())
        }
    }
}

let jsonData = arrayOfDataObjectsString().data(using: .utf8)!
let apiResponse = try JSONDecoder().decode([MyDecodedEnum].self, from: jsonData).map { AssociatedDataTypeEnum(other: $0) }

for response in apiResponse {
    print("response: \(response)")
}

//: [Next](@next)
