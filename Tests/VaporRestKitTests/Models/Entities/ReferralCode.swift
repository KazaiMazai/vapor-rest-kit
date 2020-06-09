//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 09.06.2020.
//

import Vapor
import Fluent
import VaporRestKit

extension ReferralCode: FieldsProvidingModel {
    enum Fields: String, FieldKeyRepresentable {
        case code
    }
}

final class ReferralCode: Model, Content {
    static var schema = "referal_codes"

    init() { }

    @ID(custom: .id)
    var id: Int?

    @Field(key: Fields.code.key)
    var code: String

    @Children(for: \.$refrerralCode)
    var users: [User]


    init(id: Int? = nil, code: String = "") {
        self.id = id
        self.code = code
    }
}

//MARK:- InitMigratableSchema

extension ReferralCode: InitMigratableSchema {
    static func prepare(on schemaBuilder: SchemaBuilder) -> EventLoopFuture<Void> {
        return schemaBuilder
            .field(.id, .int, .identifier(auto: true))
            .field(Fields.code.key, .string, .required)
            .create()
    }
}


extension ReferralCode {
    struct Output: ResourceOutputModel {
        let id: Int?
        let code: String

        init(_ model: ReferralCode, req: Request) {
            id = model.id
            code = model.code
        }
    }


    struct Input: ResourceUpdateModel {
        let code: String

        func update(_ model: ReferralCode) -> ReferralCode {
            model.code = code
            return model
        }

        static func validations(_ validations: inout Validations) {

        }
    }

    struct PatchInput: ResourcePatchModel {
        let code: String?

        func patch(_ model: ReferralCode) -> ReferralCode {
            model.code = code ?? model.code
            return model
        }

        static func validations(_ validations: inout Validations) {

        }
    }
}
