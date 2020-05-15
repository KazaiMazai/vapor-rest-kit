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
    }
}

final class User: Model, Content {
    static var schema = "users"

    init() { }

    @ID(custom: .id)
    var id: Int?

    @Field(key: Fields.username.key)
    var title: String

    @Children(for: \.$user)
    var todos: [Todo]

    @Siblings(through: Todo.Relations.Assignees.through, from: \.$to, to: \.$from)
    var assignedTodos: [Todo]

    init(id: Int? = nil, title: String = "") {
        self.id = id
        self.title = title
    }
}

//MARK:- InitMigratableSchema

extension User: InitMigratableSchema {
    static func prepare(on schemaBuilder: SchemaBuilder) -> EventLoopFuture<Void> {
        return schemaBuilder
            .field(.id, .int, .identifier(auto: true))
            .field(Fields.username.key, .string, .required)
            .create()
    }
}
