//: [Previous](@previous)

import Cocoa
extension String: Error { } // hah!

/*:
This it the "dirty" API model
(the naming convention is not that important)
 
Most fields are optional and mostly strings,
 since our goal is to capture as much of the API response as is available.
 
This model expresses a lot of uncertainty we have about the API response
 or how it may change in the future before we have a chance to update the app.
 
As with most swift code we want to contain the uncertainty (optionals) in a small section of the code
 */
enum API {

struct Response: Decodable {
    let data: [User?]
    let lastUpdated: String?
    let lastPage: Bool?
}

struct User: Decodable {
    let id: String?
    let firstName: String?
    let lastName: String?
    let profilePicture: String?
    let comments: [Comment?]
}

struct Comment: Decodable {
    let id: String?
    let text: String?
    let timeStamp: String?
}

}
/*:
 This is the "clean" data model I want to use with most of the UI or business logic code.
 
 Some fields are required, and the object will be useless for the app business logic if they were missing
 Some fields have sensible default values, so don't need to be optional.
 Some fields are truly optinal in that the UI using them can be hidden or disabled.
 
 The goal is to make this definitiona as convenient as possible to write your app.
 */
enum Clean {
    
struct User: Encodable {
    let id: String // id is required because I can't perform any meaningful operation with it
    let firstName: String? // I'm hide the name labels if this is missing
    let lastName: String?
    let profilePicture: URL? // I have a default image if a profile picture is missing
    let comments: [Comment]
}

struct Comment: Encodable {
    let id: String
    let text: String
    let timeStamp: Date // require that the json string for "timeStamp" has to be converted to a Date
}
    
struct Response: Encodable {
    let data: [User]
    let lastUpdated: Date
    let lastPage: Bool
}
    
}

/*:
 Convert from API Model to Clean Model using failable initializers that express what is required and what is optional using idiomatic, easy to read swift code:
 */
extension Clean.User {
    init?(_ user: API.User?) {
        guard let user = user,
            let id = user.id else {
            return nil
        }
        
        self.id = id
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.profilePicture = user.profilePicture?.toURL
        
        // drop any API.Comment objects that can't be used to create a Clean.Comment
        self.comments = user.comments.compactMap { Clean.Comment($0) }
    }
}

extension Clean.Comment {
    init?(_ comment: API.Comment?) {
        guard let comment = comment,
            let id = comment.id,
            let text = comment.text,
            let date = comment.timeStamp?.toDate(with: DateFormatter.short) else {
            return nil
        }
        self.id = id
        self.text = text
        self.timeStamp = date
    }
}

extension Clean.Response {
    init?(_ response: API.Response) {
        self.data = response.data.compactMap { Clean.User($0) }
        self.lastUpdated = response.lastUpdated?.toIso8601Date ?? Date()
        self.lastPage = response.lastPage ?? false
    }
}


/*:
 Here is example json that we expect to see returned by our API
 Try removing some fields to see how to the API to Clean conversion handles missing values
 Try changing an id from string to int to see it throw an error
 */

let jsonString = """
{
    "data": [
        {
            "id": "178790",
            "firstName": "Rowenna",
            "lastName": "Ravenclaw",
            "comments": [
                {"id": "412321", "text": "who disturbs me?", "timeStamp": "6/12/18" }
            ]
        },
        {
            "id": "18923",
            "firstName": "Wilhelmina",
            "lastName": "Grubbly-Plank",
            "comments": [
                {"id": "264632", "text": "careful, they bite!", "timeStamp": "6/11/18" },
                {"foo": "264632" }
            ]
        }
    ],
    "lastUpdated": "2018-06-12T13:01:43.587Z",
    "lastPage": true
}
"""

let jsonData = jsonString.data(using: .utf8)!
let apiResponse = try JSONDecoder().decode(API.Response.self, from: jsonData)
guard let cleanResponse = Clean.Response(apiResponse) else {
    fatalError("failed to create Clean.Response")
}

let cleanJson = try JSONEncoder(format: [.prettyPrinted],
                                dateFormat: .iso8601).encode(cleanResponse)
print(String(data: cleanJson, encoding: .utf8) ?? "")


//: [Next](@next)

