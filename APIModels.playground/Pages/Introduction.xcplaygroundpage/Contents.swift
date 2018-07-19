//: ## API Data Model
import Foundation
enum v1 {
/*:
     
## Example API Response
    
*/
struct APIResponse: Decodable {
    let data: [User]
    let last_updated: String
    let last_page: Bool
}

struct User: Decodable {
    let id: Int
    let firstName: String
    let lastName: String
    let profilePicture: String
    let comments: [Comment]
}

struct Comment: Decodable {
    let id: String
    let text: String
    let timeStamp: String
}
/*:
What could go wrong?
 * every field is required
    * decoding the entire payload will fail if any of the fields is missing or of the wrong type
 * API updated: renamed a field
 * API updated: running out of ids, needs to be a string

 *"Be conservative in what you do, be liberal in what you accept from others"*
 \- [Robustness principle](https://en.wikipedia.org/wiki/Robustness_principle)
     
What to do?
 * Option 1: write custom decoding `init(from: Decoder)`
 * Option 2: create a permissive API "import" model,
   * transform it to an "internal" model that all UI and business logic will work with
   * also called "dirty"/"clean" models

*/
}

//: [Next](@next)
