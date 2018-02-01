import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title = ""
    @objc dynamic var category = ""
    @objc dynamic var like = ""
}
