//
//  Task.swift
//  Todoey
//
//  Created by Dennis Nesanoff on 17.05.2020.
//  Copyright © 2020 Dennis Nesanoff. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCtaegory = LinkingObjects(fromType: Category.self, property: "tasks")
}
