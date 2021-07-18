//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 18.07.2021.
//

import Vapor
import Fluent

extension Model where IDValue: LosslessStringConvertible {
    static var idKey: String { Self.schema }
    static var idPathComponent: PathComponent { return PathComponent(stringLiteral: ":\(self.idKey)") }

    static func resourcePathFor(endpoint: String) -> [PathComponent] {
        let endpointPath = PathComponent(stringLiteral: endpoint)
        return [endpointPath]
    }


    static func idResourcePathFor(endpoint: String) -> [PathComponent] {
        let endpointPath = PathComponent(stringLiteral: endpoint)
        return [endpointPath, idPathComponent]
    }
}

extension Model where IDValue: LosslessStringConvertible {
    static func relatedResourcePathFor<RelatedModel>(_ model: RelatedModel.Type,
                                            relationPath: String? = nil,
                                            on endpoint: String) -> [PathComponent] where
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible {

        let endpointPath = PathComponent(stringLiteral: endpoint)
        let relationPathComponent = relationPath.map { PathComponent(stringLiteral: "\($0)")}
        return [RelatedModel.idPathComponent, relationPathComponent, endpointPath].compactMap { $0 }
    }

    static func relatedIdResourcePathFor<RelatedModel>(_ model: RelatedModel.Type,
                                              relationPath: String? = nil,
                                              on endpoint: String) -> [PathComponent]  where
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible {
        let relationPathComponent = relationPath.map { PathComponent(stringLiteral: "\($0)")}
        let endpointPath = PathComponent(stringLiteral: endpoint)
        return [RelatedModel.idPathComponent, relationPathComponent, endpointPath, Self.idPathComponent].compactMap { $0 }
    }

    static func authRelatedResourcePathFor<RelatedModel>(_ model: RelatedModel.Type,
                                            relationPath: String? = nil,
                                            on endpoint: String) -> [PathComponent] where
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible {

        let endpointPath = PathComponent(stringLiteral: endpoint)
        let relationPathComponent = relationPath.map { PathComponent(stringLiteral: "\($0)")}
        return ["me", relationPathComponent, endpointPath].compactMap { $0 }
    }

    static func authRelatedIdResourcePathFor<RelatedModel>(_ model: RelatedModel.Type,
                                              relationPath: String? = nil,
                                              on endpoint: String) -> [PathComponent]  where
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible {
        let relationPathComponent = relationPath.map { PathComponent(stringLiteral: "\($0)")}
        let endpointPath = PathComponent(stringLiteral: endpoint)
        return ["me", relationPathComponent, endpointPath, Self.idPathComponent].compactMap { $0 }
    }
}
