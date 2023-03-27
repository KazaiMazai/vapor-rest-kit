//
//  
//  
//
//  Created by Sergey Kazakov on 09.05.2020.
//

import Fluent
import Vapor

protocol PaginationCursorEncoder {
    func encode<Model: Fluent.Model>(_ model: Model, filterDescriptor: CursorFilterDescriptor) throws -> String
}

protocol PaginationCursorDecoder {
    func decode(cursor: String) throws -> [CursorValue]
}

//MARK:- PaginationCursorCoder

struct PaginationCursorCoder: PaginationCursorEncoder & PaginationCursorDecoder {
    let encoder: JSONEncoder
    let decoder: JSONDecoder

    func encode<Model: Fluent.Model>(_ model: Model, filterDescriptor: CursorFilterDescriptor) throws -> String {
        let filterDescriptors = filterDescriptor.filterDescriptors
        guard !filterDescriptors.isEmpty else {
            throw Abort(.badRequest, reason: "Cursor filters should be specified")
        }

        let fields = filterDescriptors.map { $0.field }
        let values = try model.getPropertyValuesFor(fields: fields)

        let encoded = try encoder.encode(values)
        let cursorString = encoded.base64EncodedString()
        return cursorString
    }

    func decode(cursor: String) throws -> [CursorValue] {
        guard let data = Data(base64Encoded: cursor) else {
            throw Abort(.badRequest, reason: "Cursor is malformed")
        }

        let values = try decoder.decode([CursorValue].self, from: data)
        return values
    }
}

//MARK:- CursorValue

struct CursorValue: Codable {
    let fieldKey: String
    let value: AnyCodable

    func validateKey(with field: DatabaseQuery.Field) throws {
        let codingKey = try field.codingKey()
        guard fieldKey == codingKey else {
            throw Abort(.unprocessableEntity)
        }
    }
}

//MARK:- Fluent Model Extension

extension Fluent.Model {
    fileprivate func getPropertyValuesFor(fields: [DatabaseQuery.Field]) throws -> [CursorValue] {
        var propsDict = [[FieldKey]: AnyProperty]()

        properties.compactMap {
            $0 as? AnyQueryableProperty
        }.forEach { propsDict[$0.path] = $0 }

        return try fields.map {
            let codingKey = try $0.codingKey()
            let fieldKeys = try  $0.getFieldKeys()
            let anyValue = propsDict[fieldKeys]?.unwrappedAnyValue

            return CursorValue(fieldKey: codingKey, value: AnyCodable(anyValue)) }
    }
}

//MARK:- Fluent Model Field Extension

extension DatabaseQuery.Field {
    fileprivate func codingKey() throws -> String {
        switch self {
        case .path(let keys, let schema):
            return "\(schema)_\(keys)"
        case .extendedPath(let keys, schema: let schema, space: let space):
            let spaceKey = space.map { "\($0)."} ?? ""
            return "\(spaceKey)\(schema)_\(keys)"
        case .custom:
            throw Abort(.unprocessableEntity, reason: "Custom Field is not compatible with cursor pagination")
        }
    }

    fileprivate func getFieldKeys() throws -> [FieldKey] {
        switch self {
        case .path(let keys, _):
            return keys
        case .extendedPath(let keys, _, _):
            return keys
        case .custom(_):
            throw Abort(.unprocessableEntity, reason: "Custom Field is not compatible with cursor pagination")
        }
    }
}

//MARK:- AnyProperty Extension

extension AnyProperty {
    /**
     AnyProperty's anyValue happens to be always wrapped into Optional<Any>.some(value), even when it is  nil.
     So it has to be unwrapped before checking against nil.
     */

    fileprivate var unwrappedAnyValue: Any? {
        if case Optional<Any>.some(let unwrapped) = self.anyValue {
            if case Optional<Any>.some(let unwrapped2) = unwrapped {
                return unwrapped2
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
