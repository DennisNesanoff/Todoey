//
//  Task.swift
//  Todoey
//
//  Created by Dennis Nesanoff on 17.05.2020.
//  Copyright © 2020 Dennis Nesanoff. All rights reserved.
//

import Foundation
import RealmSwift

class TaskRealm: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCtaegory = LinkingObjects(fromType: CategoryRealm.self, property: "tasks")
}
