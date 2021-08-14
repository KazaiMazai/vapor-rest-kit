//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 07.08.2021.
//

import Vapor
import Fluent

extension ResourceController {
    func patch<Input, Output>(
        req: Request,
        using: Input.Type,
        queryModifier: QueryModifier<Model>?) throws -> EventLoopFuture<Output>
    where
        Input: ResourcePatchModel,
        Output: ResourceOutputModel,
        Output.Model == Model,
        Input.Model == Output.Model {
        
        try mutate(req: req, using: using, queryModifier: queryModifier)
    }
}

extension RelatedResourceController {
    
    func patchRelated<Input, Output, RelatedModel>(
        resolver: ChildPairResolver<Model, RelatedModel>,
        req: Request,
        using: Input.Type,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Model, RelatedModel> = .defaultMiddleware,
        queryModifier: QueryModifier<Model>?,
        childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>) throws -> EventLoopFuture<Output>
    where
        Input: ResourcePatchModel,
        Output: ResourceOutputModel,
        Model == Output.Model,
        Input.Model == Output.Model {
        
        try mutateRelated(resolver: resolver,
                          req: req,
                          using: using,
                          relatedResourceMiddleware: relatedResourceMiddleware,
                          queryModifier: queryModifier,
                          childrenKeyPath: childrenKeyPath)
    }
    
    func patchRelated<Input, Output, RelatedModel>(
        resolver: ParentPairResolver<Model, RelatedModel>,
        req: Request,
        using: Input.Type,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Model, RelatedModel> = .defaultMiddleware,
        queryModifier: QueryModifier<Model>?,
        childrenKeyPath: ChildrenKeyPath<Model, RelatedModel>) throws -> EventLoopFuture<Output>
    where
        Input: ResourcePatchModel,
        Output: ResourceOutputModel,
        Model == Output.Model,
        Input.Model == Output.Model {
        
        try mutateRelated(resolver: resolver,
                          req: req,
                          using: using,
                          relatedResourceMiddleware: relatedResourceMiddleware,
                          queryModifier: queryModifier,
                          childrenKeyPath: childrenKeyPath)
    }
    
    func patchRelated<Input, Output, RelatedModel, Through>(
        resolver: SiblingsPairResolver<Model, RelatedModel, Through>,
        req: Request,
        using: Input.Type,
        relatedResourceMiddleware: RelatedResourceControllerMiddleware<Model, RelatedModel> = .defaultMiddleware,
        queryModifier: QueryModifier<Model>?,
        siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>) throws -> EventLoopFuture<Output>
    where
        
        Input: ResourcePatchModel,
        Output: ResourceOutputModel,
        Model == Output.Model,
        Input.Model == Output.Model {
        
        try mutateRelated(resolver: resolver,
                          req: req,
                          using: using,
                          relatedResourceMiddleware: relatedResourceMiddleware,
                          queryModifier: queryModifier,
                          siblingKeyPath: siblingKeyPath)
    }
}
