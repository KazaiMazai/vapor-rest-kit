//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 19.05.2020.
//

import Fluent
import Vapor
import VaporRestKit

extension StarTag: FieldsProvidingModel {
    enum Fields: String, FieldKeyRepresentable {
        case title
    }
}

final class StarTag: Model, Content {
    static var schema = "star_tags"

    init() { }

    @ID(custom: .id)
    var id: Int?

    @Field(key: Fields.title.key)
    var title: String

    @Siblings(through: Star.Relations.MarkedTags.through, from: \.$to, to: \.$from)
    var stars: [Star]

    init(id: Int? = nil, title: String = "") {
        self.id = id
        self.title = title
    }
}

//MARK:- InitMigratableSchema

extension StarTag: InitMigratableSchema {
    static func prepare(on schemaBuilder: SchemaBuilder) -> EventLoopFuture<Void> {
        return schemaBuilder
            .field(.id, .int, .identifier(auto: true))
            .field(Fields.title.key, .string, .required)
            .unique(on: Fields.title.key)
            .create()
    }
}

extension StarTag {
    struct Output: ResourceOutputModel {
        let id: Int?
        let title: String

        init(_ model: StarTag, req: Request) {
            id = model.id
            title = model.title
        }
    }

    struct CreateInput: ResourceUpdateModel {
        let title: String

        func update(_ model: StarTag) throws -> StarTag {
            model.title = title
            return model
        }

        static func validations(_ validations: inout Validations) {

        }
    }

    struct UpdateInput: ResourceUpdateModel {
        let title: String

        func update(_ model: StarTag) throws -> StarTag {
            model.title = title
            return model
        }

        static func validations(_ validations: inout Validations) {

        }
    }

    struct PatchInput: ResourcePatchModel {
        let title: String?


        func patch(_ model: StarTag) throws -> StarTag {
            model.title = title ?? model.title
            return model
        }

        static func validations(_ validations: inout Validations) {

        }
    }
}
