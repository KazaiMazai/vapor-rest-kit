//
//  
//  
//
//  Created by Sergey Kazakov on 06.04.2020.
//

import Vapor
import Fluent

//MARK:- InitMigratableSchema

public protocol InitMigratableSchema: Model {
    static func prepare(on schemaBuilder: SchemaBuilder) -> EventLoopFuture<Void>
}

public extension InitMigratableSchema {
    static func createInitialMigration(_ name: String = "InitialMigration for \(Self.schema)") -> Migration {
        Migrating<Self>.createInitialMigration(name) { db in
            prepare(on: db.schema(Self.schema))
        }
    }
    
    static func createTable(_ migrationName: String = "create_\(Self.schema)_table") -> Migration {
        Migrating<Self>.createTable(migrationName) { db in
            prepare(on: db.schema(Self.schema))
        }
    }
}

