//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 09.06.2020.
//

import Fluent
import Vapor
import VaporRestKit

extension Planet: FieldsProvidingModel {
    enum Fields: String, FieldKeyRepresentable {
        case title
        case starId
    }
}

final class Planet: Model, Content {
    static var schema = "planets"

    init() { }

    @ID(custom: .id)
    var id: Int?

    @Field(key: Fields.title.key)
    var title: String

    @OptionalParent(key: Fields.starId.key)
    var star: Star?

    init(id: Int? = nil, title: String = "") {
        self.id = id
        self.title = title
    }
}

//MARK:- InitMigratableSchema

extension Planet: InitMigratableSchema {
    static func prepare(on schemaBuilder: SchemaBuilder) -> EventLoopFuture<Void> {
        return schemaBuilder
            .field(.id, .int, .identifier(auto: true))
            .field(Fields.title.key, .string, .required)
            .field(Fields.starId.key, .int, .references(Star.schema, .id))
            .create()
    }
}



