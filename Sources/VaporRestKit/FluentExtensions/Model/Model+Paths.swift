//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 18.07.2021.
//

import Vapor
import Fluent


extension Array where Element == PathComponent {
    static func pathFor<Model>(_ model: Model.Type,
                               on endpoint: String = Model.pluralPath) -> [PathComponent]
    where
        Model: Fluent.Model,
        Model.IDValue: LosslessStringConvertible {

        let endpointPath = PathComponent(stringLiteral: endpoint)
        return [endpointPath]
    }

    static func idPathFor<Model>(_ model: Model.Type,
                                         on endpoint: String = Model.pluralPath) -> [PathComponent]
    where
        Model: Fluent.Model,
        Model.IDValue: LosslessStringConvertible {

        let endpointPath = PathComponent(stringLiteral: endpoint)
        return [endpointPath, Model.idPath]
    }
}

extension Array where Element == PathComponent {
    static func pathFor<Model, RelatedModel>(_ model: Model.Type,
                                                            relationPath: String? = nil,
                                                            relatedModel: RelatedModel.Type,
                                                            on endpoint: String = Model.pluralPath) -> [PathComponent] where
        RelatedModel: Fluent.Model,
        Model: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible,
        Model.IDValue: LosslessStringConvertible {

        let endpointPath = PathComponent(stringLiteral: endpoint)
        let relationPathComponent = relationPath.map { PathComponent(stringLiteral: "\($0)")}
        return [RelatedModel.idPath, relationPathComponent, endpointPath].compactMap { $0 }
    }

    static func idPathFor<Model, RelatedModel>(_ model: Model.Type,
                                                              relationPath: String? = nil,
                                                              relatedModel: RelatedModel.Type,
                                                              on endpoint: String = Model.pluralPath) -> [PathComponent]  where
        RelatedModel: Fluent.Model,
        Model: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible,
        Model.IDValue: LosslessStringConvertible {

        let relationPathComponent = relationPath.map { PathComponent(stringLiteral: "\($0)")}
        let endpointPath = PathComponent(stringLiteral: endpoint)
        return [RelatedModel.idPath, relationPathComponent, endpointPath, Model.idPath].compactMap { $0 }
    }

    static func authPathFor<Model, RelatedModel>(_ model: Model.Type,
                                                            relationPath: String? = nil,
                                                            relatedModel: RelatedModel.Type,
                                                            on endpoint: String = Model.pluralPath) -> [PathComponent] where
        RelatedModel: Fluent.Model,
        Model: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible,
        Model.IDValue: LosslessStringConvertible {

        let endpointPath = PathComponent(stringLiteral: endpoint)
        let relationPathComponent = relationPath.map { PathComponent(stringLiteral: "\($0)")}
        return ["me", relationPathComponent, endpointPath].compactMap { $0 }
    }

    static func authIdPathFor<Model, RelatedModel>(_ model: Model.Type,
                                                              relationPath: String? = nil,
                                                              relatedModel: RelatedModel.Type,
                                                              on endpoint: String = Model.pluralPath) -> [PathComponent]  where
        RelatedModel: Fluent.Model,
        Model: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible,
        Model.IDValue: LosslessStringConvertible {

        let relationPathComponent = relationPath.map { PathComponent(stringLiteral: "\($0)")}
        let endpointPath = PathComponent(stringLiteral: endpoint)
        return ["me", relationPathComponent, endpointPath, Model.idPath].compactMap { $0 }
    }
}

extension Model where IDValue: LosslessStringConvertible {
    static var idKey: String { Self.schema }

    static var pluralPath: String { "\(self.idKey)s"}


    public static var path: PathComponent { PathComponent(stringLiteral: pluralPath) }
    public static var idPath: PathComponent { return PathComponent(stringLiteral: ":\(self.idKey)") }
}

extension Model where IDValue: LosslessStringConvertible {
    static func relatedResourcePathFor<RelatedModel>(_ model: RelatedModel.Type,
                                                     relationPath: String? = nil,
                                                     on endpoint: String) -> [PathComponent] where
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible {

        let endpointPath = PathComponent(stringLiteral: endpoint)
        let relationPathComponent = relationPath.map { PathComponent(stringLiteral: "\($0)")}
        return [RelatedModel.idPath, relationPathComponent, endpointPath].compactMap { $0 }
    }

    static func relatedIdResourcePathFor<RelatedModel>(_ model: RelatedModel.Type,
                                                       relationPath: String? = nil,
                                                       on endpoint: String) -> [PathComponent]  where
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible {
        let relationPathComponent = relationPath.map { PathComponent(stringLiteral: "\($0)")}
        let endpointPath = PathComponent(stringLiteral: endpoint)
        return [RelatedModel.idPath, relationPathComponent, endpointPath, Self.idPath].compactMap { $0 }
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
        return ["me", relationPathComponent, endpointPath, Self.idPath].compactMap { $0 }
    }
}
