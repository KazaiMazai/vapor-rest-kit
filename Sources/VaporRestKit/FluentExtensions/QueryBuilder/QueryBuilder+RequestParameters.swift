//
//  
//  
//
//  Created by Sergey Kazakov on 28.04.2020.
//

import Fluent
import Vapor

//MARK:- QueryBuilder Extension

extension QueryBuilder where Model.IDValue: LosslessStringConvertible {
    func getIdBy(_ idKey: String, from req: Request) throws -> Model.IDValue {
        guard let id = req.parameters.get(idKey, as: Model.IDValue.self) else {
            throw Abort(.badRequest)
        }
        
        return id
    }

    func findBy(_ idKey: String, from req: Request) throws -> EventLoopFuture<Model> {
        let id = try getIdBy(idKey, from: req)

        return self.filter(\._$id == id)
                   .first()
                   .unwrap(or: Abort(.notFound))
    }
}

