//
//  Task.swift
//  Todoey
//
//  Created by Dennis Nesanoff on 15.05.2020.
//  Copyright © 2020 Dennis Nesanoff. All rights reserved.
//

import Foundation

struct Task: Codable {
    var title: String = ""
    var done: Bool = false
}
