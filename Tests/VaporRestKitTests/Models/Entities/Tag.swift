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


extension Tag {
    struct Output: ResourceOutputModel {
        let id: Int?
        let title: String

        init(_ model: Tag, req: Request) {
            id = model.id
            title = model.title
        }
    }



    struct CreateInput: ResourceUpdateModel {
        typealias Model = Tag

        let title: String

        func update(_ model: Model, req: Request, database: Database) -> EventLoopFuture<Model> {
            return req.eventLoop.makeSucceededFuture(model)
        }

        func update(_ model: Tag) throws -> Tag {
            model.title = title
            return model
        }

        static func validations(_ validations: inout Validations) {

        }
    }

    struct UpdateInput: ResourceUpdateModel {
         


 
        let title: String

        func update(_ model: Tag) throws -> Tag {
            model.title = title
            return model
        }

        static func validations(_ validations: inout Validations) {

        }
    }

    struct PatchInput: ResourcePatchModel {
        let title: String?

        
        func patch(_ model: Tag) throws -> Tag {
            model.title = title ?? model.title
            return model
        }

        static func validations(_ validations: inout Validations) {

        }
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
