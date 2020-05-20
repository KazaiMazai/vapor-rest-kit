//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 19.05.2020.
//

import Fluent
import Vapor
import VaporRestKit


extension Star: FieldsProvidingModel {
    enum Fields: String, FieldKeyRepresentable {
        case title
        case galaxyId
    }
}

extension Star {
    enum Relations {
        enum MarkedTags: SiblingRepresentable {
            typealias From = Star
            typealias To = StarTag
            typealias Through = SiblingModel<From, To, Self>
        }
    }
}

final class Star: Model, Content {
    static var schema = "stars"

    init() { }

    @ID(custom: .id)
    var id: Int?

    @Field(key: Fields.title.key)
    var title: String

    @OptionalParent(key: Fields.galaxyId.key)
    var galaxy: Galaxy?

    @Siblings(through: Star.Relations.MarkedTags.through, from: \.$from, to: \.$to)
    var starTags: [StarTag]


    init(id: Int? = nil, title: String = "") {
        self.id = id
        self.title = title
    }
}

//MARK:- InitMigratableSchema

extension Star: InitMigratableSchema {
    static func prepare(on schemaBuilder: SchemaBuilder) -> EventLoopFuture<Void> {
        return schemaBuilder
            .field(.id, .int, .identifier(auto: true))
            .field(Fields.title.key, .string, .required)
            .field(Fields.galaxyId.key, .int, .references(Galaxy.schema, .id))
            .create()
    }
}

extension Star {
    struct Output: ResourceOutputModel {
        let id: Int?
        let title: String

        init(_ model: Star, req: Request) {
            id = model.id
            title = model.title
        }
    }

    struct Input: ResourceUpdateModel {
        let title: String

        func update(_ model: Star) throws -> Star {
            model.title = title
            return model
        }

        static func validations(_ validations: inout Validations) {
            validations.add("title", as: String.self, is: .count(3...))
        }
    }

    struct PatchInput: ResourcePatchModel {
        let title: String?

        func patch(_ model: Star) throws -> Star {
            model.title = title ?? model.title
            return model
        }

        static func validations(_ validations: inout Validations) {
            validations.add("title", as: String?.self, is: .nil || .count(3...), required: false)
        }
    }
}
