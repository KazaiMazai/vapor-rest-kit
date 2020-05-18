//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 15.05.2020.
//

import VaporRestKit
import Vapor
import Fluent

extension Todo: FieldsProvidingModel {
    enum Fields: String, FieldKeyRepresentable {
        case title
        case userId
    }
}

extension Todo {
    enum Relations {
        enum MarkedTags: SiblingRepresentable {
            typealias From = Todo
            typealias To = Tag
            typealias Through = SiblingModel<Todo, Tag, Self>
        }

        enum Assignees: SiblingRepresentable {
            typealias From = Todo
            typealias To = User
            typealias Through = SiblingModel<Todo, User, Self>
        }
    }
}

final class Todo: Model, Content {
    static var schema = "todos"

    init() { }

    @ID(custom: .id)
    var id: Int?

    @Field(key: Fields.title.key)
    var title: String

    @Parent(key: Fields.userId.key)
    var user: User

    @Siblings(through: Todo.Relations.MarkedTags.through, from: \.$from, to: \.$to)
    var tags: [Tag]

    @Siblings(through: Todo.Relations.Assignees.through, from: \.$from, to: \.$to)
    var assignees: [User]

    init(id: Int? = nil, title: String = "") {
        self.id = id
        self.title = title
    }
}

//MARK:- InitMigratableSchema

extension Todo: InitMigratableSchema {
    static func prepare(on schemaBuilder: SchemaBuilder) -> EventLoopFuture<Void> {
        return schemaBuilder
            .field(.id, .int, .identifier(auto: true))
            .field(Fields.title.key, .string, .required)
            .field(Fields.userId.key, .int, .references(User.schema, .id))
            .create()
    }
}

extension Todo {
    struct Output: ResourceOutputModel {
        let id: Int?
        let title: String

        init(_ model: Todo, req: Request) {
            id = model.id
            title = model.title
        }
    }

    struct OutputV2: ResourceOutputModel {
        let id: Int?
        let name: String

        init(_ model: Todo, req: Request) {
            id = model.id
            name = model.title
        }
    }

    struct Input: ResourceUpdateModel {
         

         

        let title: String


        func update(_ model: Todo) throws -> Todo {
            model.title = title
            return model
        }

        static func validations(_ validations: inout Validations) {

        }
    }

    struct PatchInput: ResourcePatchModel {
        let title: String?

        func patch(_ model: Todo) throws -> Todo {
            model.title = title ?? model.title
            return model
        }

        static func validations(_ validations: inout Validations) {

        }
    }
}
//
//extension Todo {
//    static func seed(on database: Database) throws {
//        try Todo(title: "Wash clothes").save(on: database).wait()
//        try Todo(title: "Read book").save(on: database).wait()
//        try Todo(title: "Prepare dinner").save(on: database).wait()
//    }
//}
