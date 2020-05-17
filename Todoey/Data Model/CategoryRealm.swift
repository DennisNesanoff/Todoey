//
//  Category.swift
//  Todoey
//
//  Created by Dennis Nesanoff on 17.05.2020.
//  Copyright © 2020 Dennis Nesanoff. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryRealm: Object {
    @objc dynamic var name: String = ""
    let tasks = List<TaskRealm>()
}
