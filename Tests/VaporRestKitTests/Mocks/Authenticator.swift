//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 15.05.2020.
//

import Vapor
import Fluent

struct MockAuthenticator<User>: RequestAuthenticator where User: Fluent.Model, User: Authenticatable {
    let userId: User.IDValue

    func authenticate(request: Request) -> EventLoopFuture<User?> {
        return User.find(userId, on: request.db)
    }
}
