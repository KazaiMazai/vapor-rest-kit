//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 15.05.2020.
//

import Fluent
import Vapor
import VaporRestKit

extension Tag: FieldsProvidingModel {
    enum Fields: String, FieldKeyRepresentable {
        case title
    }
}

final class Tag: Model, Content {
    static var schema = "tags"

    init() { }

    @ID(custom: .id)
    var id: Int?

    @Field(key: Fields.title.key)
    var title: String

    @Siblings(through: Todo.Relations.MarkedTags.through, from: \.$to, to: \.$from)
    var relatedTodos: [Todo]

    init(id: Int? = nil, title: String = "") {
        self.id = id
        self.title = title
    }
}

//MARK:- InitMigratableSchema

extension Tag: InitMigratableSchema {
    static func prepare(on schemaBuilder: SchemaBuilder) -> EventLoopFuture<Void> {
        return schemaBuilder
            .field(.id, .int, .identifier(auto: true))
            .field(Fields.title.key, .string, .required)
            .create()
    }
}

//
//extension Tag {
//    static func seed(on database: Database) throws {
//        let todos = try Todo.query(on: database).all().wait()
//        try todos.forEach { todo in
//            try todo.$tags.create(Tag(title: "Important", todo_id: todo.id!), on: database).wait()
//        }
//    }
//}
