//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 04.05.2020.
//

import Vapor
import Fluent

protocol CreatableRelationController: ItemResourceControllerProtocol {
    func create(_ req: Request) throws -> EventLoopFuture<Output>
}

extension CreatableRelationController where Self: ChildrenResourceRelationProviding {
    func create(_ req: Request) throws -> EventLoopFuture<Output> {
        return try self.findWithRelated(req)
                       .flatMapThrowing { try $0.resource.attached(to: $0.relatedResource, with: self.childrenKeyPath) }
                       .flatMap { resource in return resource.save(on: req.db)
                                                             .transform(to: Output(resource)) }
    }
}

extension CreatableRelationController where Self: ParentResourceRelationProviding {
      func create(_ req: Request) throws -> EventLoopFuture<Output> {
        return try self.findWithRelated(req)
                       .flatMapThrowing {
                            try $0.resource.attached(to: $0.relatedResource, with: self.inversedChildrenKeyPath)
                            let resource = $0.resource
                            return $0.relatedResource.save(on: req.db)
                                                     .transform(to: resource)}
                       .flatMap { $0 }
                       .map { Output($0) }
    }
}

extension CreatableRelationController where Self: SiblingsResourceRelationProviding {
    func create(_ req: Request) throws -> EventLoopFuture<Output> {
        return try findWithRelated(req)
                    .flatMap { $0.resource.attached(to: $0.relatedResoure, with: self.siblingKeyPath, on: req.db) }
                    .map { Output($0)}
    }
}

