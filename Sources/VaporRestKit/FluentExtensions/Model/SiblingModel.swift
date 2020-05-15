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
    where
    From: Fluent.Model,
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

extension SiblingModel: InitMigratableSchema {
    public static func prepare(on schemaBuilder: SchemaBuilder) -> EventLoopFuture<Void> {
        guard let fromIdType = DatabaseSchema.DataType(type: From.IDValue.self) else {
            return schemaBuilder.create()
                                .eventLoop
                                .makeFailedFuture(FluentError.invalidField(name: "\(From.schema).id",
                                    valueType: From.IDValue.self,
                                    error: SiblingModelError.idTypeUnsupported))
        }


        guard let toIdType = DatabaseSchema.DataType(type: From.IDValue.self) else {
            return schemaBuilder.create()
                                .eventLoop
                                .makeFailedFuture(FluentError.invalidField(name: "\(To.schema).id",
                                    valueType: To.IDValue.self,
                                    error: SiblingModelError.idTypeUnsupported))
        }

        return schemaBuilder
            .id()
            .field(Fields.fromId.key, fromIdType, .required, .references(From.schema, .id))
            .field(Fields.toId.key, toIdType, .required, .references(To.schema, .id))
            .create()
    }
}


fileprivate extension DatabaseSchema.DataType {
    init?<T>(type: T.Type) {
        switch type.self {
        case is UUID.Type:
            self = .uuid
        case is Bool.Type:
            self = .bool
        case is Int.Type:
            self = .int
        case is Int8.Type:
            self = .int8
        case is Int16.Type:
            self = .int16
        case is Int32.Type:
            self = .int32
        case is Int64.Type:
            self = .int64
        case is UInt.Type:
            self = .uint
        case is UInt8.Type:
            self = .uint8
        case is UInt16.Type:
            self = .uint16
        case is UInt32.Type:
            self = .uint32
        case is UInt64.Type:
            self = .uint64
        case is Float.Type:
            self = .float
        case is Double.Type:
            self = .double
        case  is String.Type:
            self = .string
        case is Date.Type:
            self = .date
        default:
            return nil
        }
    }
}


fileprivate enum SiblingModelError: Error, LocalizedError, CustomStringConvertible {
    case idTypeUnsupported

    var description: String {
        switch self {
        case .idTypeUnsupported:
            return "ID type is not supported"
        }
    }

    var errorDescription: String? {
        return self.description
    }
}
