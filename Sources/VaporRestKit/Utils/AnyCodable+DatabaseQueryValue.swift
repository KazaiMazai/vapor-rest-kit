//
//  
//  
//
//  Created by Sergey Kazakov on 08.05.2020.
//

import Vapor
import Fluent

//MARK:- AnyCodable Extension

extension AnyCodable {
    func toDatabaseQueryValue() throws -> DatabaseQuery.Value {
        switch self.value {
        case is Void:
            return .null
        case let uuid as UUID:
            return .bind(uuid)
        case let bool as Bool:
            return .bind(bool)
        case let int as Int:
            return .bind(int)
        case let int8 as Int8:
            return .bind(int8)
        case let int16 as Int16:
            return .bind(int16)
        case let int32 as Int32:
            return .bind(int32)
        case let int64 as Int64:
            return .bind(int64)
        case let uint as UInt:
            return .bind(uint)
        case let uint8 as UInt8:
            return .bind(uint8)
        case let uint16 as UInt16:
            return .bind(uint16)
        case let uint32 as UInt32:
            return .bind(uint32)
        case let uint64 as UInt64:
            return .bind(uint64)
        case let float as Float:
            return .bind(float)
        case let double as Double:
            return .bind(double)
        case let string as String:
            return .bind(string)
        case let date as Date:
            return .bind(date)
        case let url as URL:
            return .bind(url)
        case let array as [Any?]:
            return .array(try array.map { try AnyCodable($0).toDatabaseQueryValue() })
        case let dictionary as [String: Any?]:
            let uniqueKeysWithValues = try dictionary.map { (key, value) in
                return (FieldKey(stringLiteral: key), try AnyCodable(value).toDatabaseQueryValue())
            }
            return .dictionary(Dictionary(uniqueKeysWithValues: uniqueKeysWithValues))
        default:
            let context = EncodingError.Context(codingPath: [],
                                                debugDescription: "AnyCodable cannot be represented as DatabaseQuery Value")
            throw EncodingError.invalidValue(self.value, context)
        }
    }
}



