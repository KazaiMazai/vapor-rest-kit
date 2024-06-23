//
//  
//  
//
//  Created by Sergey Kazakov on 06.04.2020.
//

import Vapor
import Fluent

//MARK:- InitialMigration

public struct Migrating<T: Model> {
    public typealias MigratingClosure = @Sendable (Database) -> EventLoopFuture<Void>

    public let name: String
    private let prepareClosure: MigratingClosure
    private let revertClosure: MigratingClosure

    init(name: String,
         with prepareClosure: @escaping MigratingClosure,
         revertClosure: @escaping MigratingClosure) {
        self.name = name
        self.prepareClosure = prepareClosure
        self.revertClosure = revertClosure
    }
}

extension Migrating: Migration {
    public func prepare(on database: Database) -> EventLoopFuture<Void> {
        prepareClosure(database)
    }

    public func revert(on database: Database) -> EventLoopFuture<Void> {
        revertClosure(database)
    }
}

public extension Migrating {
    static func createInitialMigration(
        with prepare: @escaping MigratingClosure,
        revert: @escaping MigratingClosure = { db in db.schema(T.schema).delete() }) -> Migrating {

        Migrating(
            name: "InitialMigration for \(T.schema)",
            with: prepare,
            revertClosure: revert)
    }
}
