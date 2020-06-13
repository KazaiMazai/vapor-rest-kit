//
//  
//  
//
//  Created by Sergey Kazakov on 09.05.2020.
//

import Fluent
import Vapor

//MARK:- PaginationCursor

struct PaginationCursor {
    let cursorString: String
    let values: [CursorValue]

    init?<Model: Fluent.Model>(_ model: Model?, cursorFilters: [FilterDescriptor]) throws {
        guard let model = model else {
            return nil
        }

        guard !cursorFilters.isEmpty else {
            throw Abort(.badRequest, reason: "Cursor filters should be specified")
        }

        let fields = cursorFilters.map { $0.field }
        self.values = try model.getPropertyValuesFor(fields: fields)

        let encoded = try JSONEncoder().encode(self.values)
        cursorString = encoded.base64EncodedString()
    }

    init(_ cursor: String) throws {
        guard let data = Data(base64Encoded: cursor) else {
            throw Abort(.badRequest, reason: "Cursor is malformed")
        }

        cursorString = cursor
        self.values = try JSONDecoder().decode([CursorValue].self, from: data)
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
            let key = try $0.codingKey()
            let fieldKeys = try  $0.getFieldKeys().fieldKeys
            let anyValue = propsDict[fieldKeys]?.unwrappedAnyValue

            return CursorValue(fieldKey: key, value: AnyCodable(anyValue)) }
    }
}

//MARK:- Fluent Model Field Extension

extension DatabaseQuery.Field {
    fileprivate func codingKey() throws -> String {
        switch self {
        case .path(let keys, let schema):
            return "\(schema)_\(keys)"
        case .custom(_):
            throw Abort(.unprocessableEntity, reason: "Custom Field is not compatible with cursor pagination")
        }
    }

    fileprivate func getFieldKeys() throws -> (fieldKeys: [FieldKey], schema: String) {
        switch self {
        case .path(let keys, let schema):
            return  (fieldKeys: keys, schema: schema)
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
            if case Optional<Any>.some(let unwrapped2) =  unwrapped {
                return unwrapped2
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
