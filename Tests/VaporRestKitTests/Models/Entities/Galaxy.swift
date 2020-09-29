//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 19.05.2020.
//

import Fluent
import Vapor
import VaporRestKit


extension Galaxy: FieldsProvidingModel {
    enum Fields: String, FieldKeyRepresentable {
        case title
    }
}

final class Galaxy: Model, Content {
    static var schema = "galaxies"

    init() { }

    @ID(custom: .id)
    var id: Int?

    @Field(key: Fields.title.key)
    var title: String


    @Children(for: \.$galaxy)
    var stars: [Star]

    init(id: Int? = nil, title: String = "") {
        self.id = id
        self.title = title
    }
}

//MARK:- InitMigratableSchema

extension Galaxy: InitMigratableSchema {
    static func prepare(on schemaBuilder: SchemaBuilder) -> EventLoopFuture<Void> {
        return schemaBuilder
            .field(.id, .int, .identifier(auto: true))
            .field(Fields.title.key, .string, .required)
            .unique(on: Fields.title.key)
            .create()
    }
}

extension Galaxy {
    struct Output: ResourceOutputModel {
        let id: Int?
        let title: String

        init(_ model: Galaxy, req: Request) {
            id = model.id
            title = model.title
        }
    }

    struct ExtendedOutput<StarOutput>: ResourceOutputModel
        where
        StarOutput: ResourceOutputModel,
        StarOutput.Model == Star {

        let id: Int?
        let title: String
        let stars: [StarOutput]?

        init(_ model: Galaxy, req: Request) throws {
            id = model.id
            title = model.title
            stars = try model.$stars.value?.map { try StarOutput($0, req: req) }
        }
    }

    struct Input: ResourceUpdateModel {
        typealias Model = Galaxy

        let title: String

        func update(_ model: Galaxy) -> Galaxy {
            model.title = title
            return model
        }

        static func validations(_ validations: inout Validations) {
            validations.add("title", as: String.self, is: .count(2...))
        }
    }

    struct PatchInput: ResourcePatchModel {
        let title: String?

        func patch(_ model: Galaxy) -> Galaxy {
            model.title = title ?? model.title
            return model
        }

        static func validations(_ validations: inout Validations) {
            validations.add("title", as: String?.self, is: .nil || .count(2...), required: false)
        }
    }
}


