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
    func getIdParameter(_ idKey: String, from req: Request) throws -> Model.IDValue {
        guard let id = req.parameters.get(idKey, as: Model.IDValue.self) else {
            throw Abort(.badRequest)
        }
        
        return id
    }
    
    func find(by idKey: String, from req: Request) throws -> EventLoopFuture<Model> {
        let id = try getIdParameter(idKey, from: req)
        
        return self.filter(\._$id == id)
            .first()
            .unwrap(or: Abort(.notFound))
    }
}

extension QueryBuilder {
    func find(by id: Model.IDValue) -> EventLoopFuture<Model> {
        filter(\._$id == id)
            .first()
            .unwrap(or: Abort(.notFound))
    }
}

