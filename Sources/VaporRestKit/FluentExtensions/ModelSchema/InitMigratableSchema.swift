//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 06.04.2020.
//

import Vapor
import Fluent

//MARK:- InitMigratableSchema

protocol InitMigratableSchema: FieldsProvidingModel {
    static func prepare(on schemaBuilder: SchemaBuilder) -> EventLoopFuture<Void>
}

extension InitMigratableSchema {
    static func createInitialMigration() -> InitialMigration<Self> {
        return InitialMigration(with: prepare)
    }
}

