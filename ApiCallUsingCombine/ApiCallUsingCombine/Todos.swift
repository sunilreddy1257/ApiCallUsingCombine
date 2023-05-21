//
//  Todos.swift
//  ApiCallUsingCombine
//
//  Created by Sunil Kumar Reddy Sanepalli on 21/05/23.
//

import Foundation

struct Todos: Codable {

    let userId: Int
    let id: Int
    let title: String
    let completed: Bool

}

enum NetworkError: Error {
    case responseError
    case parseError
    case invalidURL
    case decodingError
}
