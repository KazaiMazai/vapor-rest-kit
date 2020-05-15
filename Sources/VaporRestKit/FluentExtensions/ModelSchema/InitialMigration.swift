//
//  
//  
//
//  Created by Sergey Kazakov on 06.04.2020.
//

import Vapor
import Fluent

//MARK:- InitialMigration

struct InitialMigration<T: FieldsProvidingModel> {
    typealias PrepareClosure = (SchemaBuilder) -> EventLoopFuture<Void>

    private let prepareClosure: PrepareClosure

    init(with prepareClosure: @escaping PrepareClosure) {
        self.prepareClosure = prepareClosure
    }
}

extension InitialMigration {
    var name: String {
        return "InitialMigration for \(T.schema)"
    }

    var modelSchema: String {
        return T.schema
    }
}

extension InitialMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        prepareClosure(database.schema(modelSchema))
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(modelSchema).delete()
    }
}
