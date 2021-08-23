//
//  Models.swift
//  RxTemp
//
//  Created by Aaron Connolly on 8/20/21.
//

import Foundation

struct User: Equatable {
    let name: String
    let age: Int
}

struct Movie: Equatable {
    let name: String
    let director: String
}

// MARK: - Mocks

extension User {
    static let mock = Self(name: "John Doe", age: 41)
}

extension Movie {
    static let mock = Self(name: "Attack of The Software Bugs", director: "John Doe")
}
