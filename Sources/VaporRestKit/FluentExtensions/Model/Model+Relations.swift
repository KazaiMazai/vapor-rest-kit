//
//  
//  
//
//  Created by Sergey Kazakov on 29.04.2020.
//

import Vapor
import Fluent

//MARK:- ChildrenKeyPath

public typealias ChildrenKeyPath<From: Fluent.Model, To: Fluent.Model> = KeyPath<From, ChildrenProperty<From, To>>

//MARK:- SiblingKeyPath

public typealias SiblingKeyPath<From: Fluent.Model, To: Fluent.Model, Through: Fluent.Model> = KeyPath<From, SiblingsProperty<From, To, Through>>

//MARK:- Model + Relations Extension

extension Model {
    @discardableResult
    func attached<From>(to parent: From,
                           with childrenKeyPath: ChildrenKeyPath<From, Self>) throws -> Self {

            switch parent[keyPath: childrenKeyPath].parentKey {
            case .required(let requiredKeyPath):
                self[keyPath: requiredKeyPath].id = try parent.requireID()
            case .optional(let optionalKeyPath):
                self[keyPath: optionalKeyPath].id = parent.id
            }

            return self
    }

    @discardableResult
    func detached<From>(from parent: From,
                           with childrenKeyPath: ChildrenKeyPath<From, Self>) throws -> Self {

            switch parent[keyPath: childrenKeyPath].parentKey {
            case .required(_):
                throw FluentError.idRequired
            case .optional(let optionalKeyPath):
                self[keyPath: optionalKeyPath].id = nil
            }

            return self
    }

    @discardableResult
    func attached<To>(to child: To,
                          with childrenKeyPath: ChildrenKeyPath<Self, To>) throws -> Self {

        switch self[keyPath: childrenKeyPath].parentKey {
        case .required(let requiredKeyPath):
            child[keyPath: requiredKeyPath].id = try self.requireID()
        case .optional(let optionalKeyPath):
            child[keyPath: optionalKeyPath].id = self.id
        }
        return self
    }

    @discardableResult
    func detached<To>(from child: To,
                          with childrenKeyPath: ChildrenKeyPath<Self, To>) throws -> Self {

        switch self[keyPath: childrenKeyPath].parentKey {
        case .required(_):
            throw FluentError.idRequired
        case .optional(let optionalKeyPath):
            child[keyPath: optionalKeyPath].id = self.id
        }
        return self
    }

    @discardableResult
    func attached<To, Through>(to child: To,
                               with childrenKeyPath: SiblingKeyPath<Self, To, Through>, on database: Database,
                               method: SiblingsProperty<Self, To, Through>.AttachMethod = .ifNotExists,
                               edit: @escaping (Through) -> () = { _ in }) -> EventLoopFuture<Self> {

        return self[keyPath: childrenKeyPath].attach(child, method: method, on: database, edit)
                                             .transform(to: self)

    }

    @discardableResult
    func detached<To, Through>(from child: To,
                               with childrenKeyPath: SiblingKeyPath<Self, To, Through>, on database: Database) -> EventLoopFuture<Self> {
        return self[keyPath: childrenKeyPath].detach(child, on: database)
                                             .transform(to: self)
    }

    @discardableResult
    func attached<From, Through>(to parent: From,
                                  with siblingKeyPath: SiblingKeyPath<From, Self, Through>,
                                  on database: Database,
                                  method: SiblingsProperty<From, Self, Through>.AttachMethod = .ifNotExists,
                                  edit: @escaping (Through) -> () = { _ in }) -> EventLoopFuture<Self> {

        return parent[keyPath: siblingKeyPath].attach(self, method: method, on: database, edit)
                                              .transform(to: self)
    }
    @discardableResult
    func detached<From, Through>(from parent: From,
                                  with siblingKeyPath: SiblingKeyPath<From, Self, Through>,
                                  on database: Database) -> EventLoopFuture<Self> {

        return parent[keyPath: siblingKeyPath].detach(self, on: database)
                                              .transform(to: self)
    }

    @discardableResult
    func getParentKey<From>(with childrenKeyPath: ChildrenKeyPath<From, Self>) -> ChildrenProperty<From, Self>.Key {

            return From()[keyPath: childrenKeyPath].parentKey
    }

    func query<From>(keyPath childrenKeyPath: ChildrenKeyPath<From, Self>,
                              on database: Database) -> QueryBuilder<From>
        where From: Fluent.Model {

        let parentKey = getParentKey(with: childrenKeyPath)

        switch parentKey {
        case .required(let requiredKeyPath):
            return self[keyPath: requiredKeyPath].query(on: database)
        case .optional(let optionalKeyPath):
            return self[keyPath: optionalKeyPath].query(on: database)
        }
    }

    func query<To>(keyPath childrenKeyPath: ChildrenKeyPath<Self, To>,
                            on database: Database) -> QueryBuilder<To> {
        return self[keyPath: childrenKeyPath].query(on: database)
    }

    func queryRelated<To, Through>(keyPath siblingKeyPath: SiblingKeyPath<Self, To, Through>,
                                    on database: Database) -> QueryBuilder<To> {
        return self[keyPath: siblingKeyPath].query(on: database)
    }
}
