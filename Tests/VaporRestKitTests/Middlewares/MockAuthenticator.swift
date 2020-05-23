//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 15.05.2020.
//

import Vapor
import Fluent

struct MockAuthenticator<AuthModel>: RequestAuthenticator where AuthModel: Fluent.Model, AuthModel: Authenticatable {
    let userId: AuthModel.IDValue

    func authenticate(request: Request) -> EventLoopFuture<Void> {
        return AuthModel.find(userId, on: request.db)
                        .map { authModel in
                            guard let model = authModel else {
                                return Void()
                            }

                            request.auth.login(model)
                            return Void()
                        }

    }
}
