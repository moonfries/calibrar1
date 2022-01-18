//
//  TodoService.swift
//  Calibrar1
//
//  Created by Jake Aranas on 1/18/22.
//

import Foundation
import Moya

enum TodoServices {
    case createTodo(title: String)
    case readTodos
    case deleteTodo(id: Int)
}

extension TodoServices: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com") else { return URL(string: "")!}
        return url
    }

    var path: String {
        switch self {
            case .createTodo(_), .readTodos:
                return "/todos"
            case .deleteTodo(let id):
                return "/todos/\(id)"
        }
    }

    var method: Moya.Method {
        switch self {
            case .createTodo(_):
                return .post

            case .readTodos:
                return .get


            case .deleteTodo(_):
                return .delete
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
            case .deleteTodo(_), .readTodos:
                return .requestPlain
            case .createTodo(let title):
                return .requestParameters(parameters: ["title": title], encoding: JSONEncoding.default)
        }
    }

    var headers: [String : String]? {
        return ["Content-Type":"application/json"]
    }


}


