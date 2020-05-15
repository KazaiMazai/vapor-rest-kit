//
//  
//  
//
//  Created by Sergey Kazakov on 02.05.2020.
//

import Vapor
import Fluent

//MARK:- SiblingRepresentable

public protocol SiblingRepresentable where From: Model, To: Model, Through: Model {
    associatedtype From
    associatedtype To
    associatedtype Through

    static var siblingName: String { get }
    static var through: SiblingModel<From, To, Self>.Type { get }
}

public extension SiblingRepresentable {
    static var siblingName: String  { String(describing: self).camelCaseToSnakeCase() }

    static var through: SiblingModel<From, To, Self>.Type { return SiblingModel<From, To, Self>.self }
}

//MARK:- SiblingModel

public final class SiblingModel<From, To, Name>: Model, Content
    where From: Fluent.Model,
        To: Fluent.Model,
        Name: SiblingRepresentable {

    public static var schema: String {
        return "\(From.schema)_\(To.schema)_\(Name.siblingName)_pivot"
    }

    @ID(key: .id)
    public var id: UUID?

    @Parent(key: Fields.fromId.key)
    public var from: From

    @Parent(key: Fields.toId.key)
    public var to: To

    public init() { }

    public init(fromId: From.IDValue , toId: To.IDValue) {
        self.$from.id = fromId
        self.$to.id = toId
    }
}

//MARK:- SiblingModel + FieldsProvidingModel

extension SiblingModel: FieldsProvidingModel {
    public enum Fields: String, FieldKeyRepresentable {
        case fromId
        case toId
    }
}


//MARK:- SiblingModel + InitMigratableSchema

extension SiblingModel: InitMigratableSchema where From.IDValue == UUID, To.IDValue == UUID  {
    public static func prepare(on schemaBuilder: SchemaBuilder) -> EventLoopFuture<Void> {
        return schemaBuilder
            .id()
            .field(Fields.fromId.key, .uuid, .required, .references(From.schema, .id))
            .field(Fields.toId.key, .uuid, .required, .references(To.schema, .id))
            .create()
    }
}


