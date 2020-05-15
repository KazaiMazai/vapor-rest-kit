//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 15.05.2020.
//

import Vapor
import Fluent
import VaporRestKit

extension User: FieldsProvidingModel {
    enum Fields: String, FieldKeyRepresentable {
        case username
        case age
    }
}

final class User: Model, Content {
    static var schema = "users"

    init() { }

    @ID(custom: .id)
    var id: Int?

    @Field(key: Fields.username.key)
    var username: String

    @Field(key: Fields.age.key)
    var age: Int


    @Children(for: \.$user)
    var todos: [Todo]

    @Siblings(through: Todo.Relations.Assignees.through, from: \.$to, to: \.$from)
    var assignedTodos: [Todo]

    init(id: Int? = nil, username: String = "", age: Int = 0) {
        self.id = id
        self.username = username
        self.age = age
    }
}

//MARK:- InitMigratableSchema

extension User: InitMigratableSchema {
    static func prepare(on schemaBuilder: SchemaBuilder) -> EventLoopFuture<Void> {
        return schemaBuilder
            .field(.id, .int, .identifier(auto: true))
            .field(Fields.username.key, .string, .required)
            .field(Fields.age.key, .int, .required)
            .create()
    }
}


extension User {
    struct Output: ResourceOutputModel {
        let id: Int?
        let username: String
        let age: Int

        init(_ model: User) {
            id = model.id
            username = model.username
            age = model.age
        }
    }

    struct OutputV2: ResourceOutputModel {
        let id: Int?
        let username: String

        init(_ model: User) {
            id = model.id
            username = model.username
        }
    }

    struct Input: ResourceUpdateModel {
        let username: String
        let age: Int

        func update(_ model: User) -> User {
            model.username = username
            model.age = age

            return model
        }

        static func validations(_ validations: inout Validations) {
            validations.add("username", as: String.self, is: .count(3...))
            validations.add("age", as: Int.self, is: .range(0...200))
        }
    }

    struct PatchInput: ResourcePatchModel {
        let username: String?
        let age: Int?

        func patch(_ model: User) -> User {
            model.username = username ?? model.username
            model.age = age ?? model.age

            return model
        }

        static func validations(_ validations: inout Validations) {
            validations.add("username", as: String?.self, is: .nil || .count(3...), required: false)
            validations.add("age", as: Int.self, is: .range(0...200))
        }
    }
}


extension User: Authenticatable {

}
