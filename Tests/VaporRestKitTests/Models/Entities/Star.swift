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
        case subtitle
        case galaxyId
        case size
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

    @Field(key: Fields.subtitle.key)
    var subtitle: String?

    @Field(key: Fields.size.key)
    var size: Int

    @OptionalParent(key: Fields.galaxyId.key)
    var galaxy: Galaxy?

    @Children(for: \Planet.$star)
    var planets: [Planet]

    @Siblings(through: Star.Relations.MarkedTags.through, from: \.$from, to: \.$to)
    var starTags: [StarTag]

    init(id: Int? = nil, title: String = "", subtitle: String? = nil, size: Int = 0) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.size = size
    }
}

//MARK:- InitMigratableSchema

extension Star: InitMigratableSchema {
    static func prepare(on schemaBuilder: SchemaBuilder) -> EventLoopFuture<Void> {
        return schemaBuilder
            .field(.id, .int, .identifier(auto: true))
            .field(Fields.title.key, .string, .required)
            .field(Fields.subtitle.key, .string)
            .field(Fields.size.key, .int)
            .field(Fields.galaxyId.key, .int, .references(Galaxy.schema, .id))
            .create()
    }
}

extension Star {
    struct Output: ResourceOutputModel, Equatable {
        let id: Int?
        let title: String
        let subtitle: String?
        let size: Int

        init(_ model: Star, req: Request) {
            id = model.id
            title = model.title
            subtitle = model.subtitle
            size = model.size
        }

        init(_ model: Star) {
            id = model.id
            title = model.title
            subtitle = model.subtitle
            size = model.size
        }
    }

    struct ExtendedOutput<GalaxyOutput, TagsOutput>: ResourceOutputModel
        where
        GalaxyOutput: ResourceOutputModel,
        GalaxyOutput.Model == Galaxy,
        TagsOutput: ResourceOutputModel,
        TagsOutput.Model == StarTag  {

        let id: Int?
        let title: String
        let subtitle: String?
        let size: Int

        let galaxy: GalaxyOutput?
        let tags: [TagsOutput]?

        init(_ model: Star, req: Request) throws {
            id = model.id
            title = model.title
            subtitle = model.subtitle
            size = model.size
            galaxy = try model.$galaxy.value?.map { try GalaxyOutput($0, req: req) }
            tags = try model.$starTags.value?.map { try TagsOutput($0, req: req) }
        }
    }

    

    struct Input: ResourceUpdateModel {
        typealias Model = Star

        let title: String

        func update(_ model: Star) throws -> Star {
            model.title = title
            model.subtitle = nil
            model.size = 0
            return model
        }

        static func validations(_ validations: inout Validations) {
            validations.add("title", as: String.self, is: .count(3...))
        }
    }

    struct PatchInput: ResourcePatchModel {
        typealias Model = Star

        let title: String?
        let subtitle: String?

        init(title: String? = nil, subtitle: String? = nil) {
            self.title = title
            self.subtitle = subtitle
        }

        func patch(_ model: Star) throws -> Star {
            model.title = title ?? model.title
            model.subtitle = subtitle ?? model.subtitle
            return model
        }

        static func validations(_ validations: inout Validations) {
            validations.add("title", as: String?.self, is: .nil || .count(3...), required: false)
        }
    }
}


extension Star {
    static let seedTitles: [(title: String, subtitle: String?)] = [
        ("AnyStar", nil),
        ("AnyStar", "A"),
        ("AnyStar", "Z"),
        ("A","A"),
        ("Z","Z"),
        ("A",nil),
        ("Z", nil),
        ("Sun", "S"),
        ("Canis Majoris", "A"),
        ("Cephei", "B"),
        ("Cygni", "C"),
        ("Sagittarii", "D"),
        ("Betelgeuse", "E"),
        ("Antares", "E"),
        ("Monocerotis", "F"),
        ("Monocerotis", "F"),
        ("Monocerotis", nil)
    ]

    static func seed(on database: Database) throws {
        let galaxy = Galaxy(title: "Milky Way")


        try galaxy.save(on: database).wait()

        let starTag = StarTag(title: "Small")
        try starTag.save(on: database).wait()

        let planet = Planet(title: "Earth")
        

        try seedTitles.enumerated().forEach  {
            let size = $0.offset * 10
            let star = Star(title: $0.element.title, subtitle: $0.element.subtitle, size: size)
            star.$galaxy.id = galaxy.id
            try star.save(on: database).wait()
            if star.title == "Sun" {
                planet.$star.id = star.id
                try planet.save(on: database).wait()
            }

            try star.$starTags.attach(starTag, on: database).wait()
        }
    }
}
