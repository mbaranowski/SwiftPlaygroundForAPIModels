import Foundation


public struct DataImage: Decodable {
    let url: String
    let caption: String?
}

public struct DataVideo: Decodable {
    let url: String
    let title: String?
    let length: String?
}

public struct DataArticle: Decodable {
    let url: String
    let title: String?
    let content: String?
}

public struct DataOpinion: Decodable {
    let url: String
    let title: String?
    let content: String?
}

public enum DataTypeString: String, Decodable {
    case image
    case video
    case article
    case opinion
}

public enum AssociatedDataTypeEnum {
    case image(DataImage)
    case video(DataVideo)
    case article(DataArticle)
    case opinion(DataOpinion)
}

public func arrayOfDataObjectsString() -> String {
    return """
[
{ "type": "image", "url": "http://placekitten.com/200/300", "caption": "foof" },
{ "type": "video", "url": "http://placekitten.com/200/300", "title": "foof", "length": "5m" },
{ "type": "article", "url": "http://placekitten.com/200/300", "title": "foof", "content": "asdfadsdf" },
{ "type": "opinion", "url": "http://placekitten.com/200/300", "title": "foof", "content": "asdfadsdf" },
{ "type": "image", "url": "http://placekitten.com/200/300", "caption": "foof" }
]
"""
}
