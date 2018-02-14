import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title = ""
    @objc dynamic var category = ""
    @objc dynamic var like = ""
}

class Information: Object {
    @objc dynamic var you_id = ""
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var mach = ""
    @objc dynamic var pr = ""
    @objc dynamic var flag: Int = 0
}

class My_Information: Object {
    @objc dynamic var name = ""
    @objc dynamic var pr = ""
}

class Id: Object {
    @objc dynamic var my_id = ""
}
