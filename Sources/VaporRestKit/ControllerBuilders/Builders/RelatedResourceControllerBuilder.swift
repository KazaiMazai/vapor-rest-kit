//
//  
//  
//
//  Created by Sergey Kazakov on 15.05.2020.
//

import Vapor
import Fluent

public final class RelatedResourceControllerBuilder<Model, RelatedModel, Output, EagerLoading>: APIMethodsProviding
    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible {

    internal let resourceControllerBuilder: ResourceControllerBuilder<Model, Output, EagerLoading>
    internal let keyPathType: KeyPathType
    internal let relationName: String

    internal init(_ resourceControllerBuilder: ResourceControllerBuilder<Model, Output, EagerLoading>,
                  childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>,
                  relationName: String) {

        self.resourceControllerBuilder = resourceControllerBuilder
        self.keyPathType = .children(childrenKeyPath)
        self.relationName = relationName
    }

    internal init(_ resourceFactory: ResourceControllerBuilder<Model, Output, EagerLoading>,
                  childrenKeyPath: ChildrenKeyPath<Model, RelatedModel>,
                  relationName: String) {

        self.resourceControllerBuilder = resourceFactory
        self.keyPathType = .inversedChildren(childrenKeyPath)
        self.relationName = relationName
    }

    internal enum KeyPathType {
        case children(ChildrenKeyPath<RelatedModel, Model>)
        case inversedChildren(ChildrenKeyPath<Model, RelatedModel>)
    }

    fileprivate var controllers: [APIMethodsProviding] = []

    fileprivate func adding(_ controller: APIMethodsProviding) -> RelatedResourceControllerBuilder  {
        controllers.append(controller)
        return self
    }
}

public extension RelatedResourceControllerBuilder {
    var relation: RelationControllerBuilder<Model, RelatedModel, Output, EagerLoading> {
        return RelationControllerBuilder<Model, RelatedModel, Output, EagerLoading>(resourceControllerBuilder: self)
    }
}

public extension RelatedResourceControllerBuilder {
    func addMethodsTo(_ routeBuilder: RoutesBuilder, on endpoint: String) {
        resourceControllerBuilder.addMethodsTo(routeBuilder, on: endpoint)
        CompoundResourceController(with: controllers).addMethodsTo(routeBuilder, on: endpoint)
    }
}

public extension RelatedResourceControllerBuilder {
    func create<Input>(with: Input.Type) -> RelatedResourceControllerBuilder
        where
        Input: ResourceUpdateModel,
        Model == Input.Model  {

            switch keyPathType {
            case .children(let relationKeyPath):
                return adding(CreateChildrenResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  childrenKeyPath: relationKeyPath))

            case .inversedChildren(let relationKeyPath):
                return adding(CreateParentResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  inversedChildrenKeyPath: relationKeyPath))
            }
    }

    func read() -> RelatedResourceControllerBuilder {
            switch keyPathType {
            case .children(let relationKeyPath):
                return adding(ReadChildrenResourceController<Model,
                    RelatedModel,
                    Output,
                    EagerLoading>(relationNamePath: relationName,
                                  childrenKeyPath: relationKeyPath))

            case .inversedChildren(let relationKeyPath):
                return adding(ReadParentResourceController<Model,
                    RelatedModel,
                    Output,
                    EagerLoading>(relationNamePath: relationName,
                                  inversedChildrenKeyPath: relationKeyPath))
            }
    }

    func update<Input>(with: Input.Type) -> RelatedResourceControllerBuilder
        where
        Input: ResourceUpdateModel,
        Model == Input.Model  {

            switch keyPathType {
            case .children(let relationKeyPath):
                return adding(UpdateChildrenResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  childrenKeyPath: relationKeyPath))
            case .inversedChildren(let relationKeyPath):
                return adding(UpdateParentResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  inversedChildrenKeyPath: relationKeyPath))
            }
    }

    func patch<Input>(with: Input.Type) -> RelatedResourceControllerBuilder
        where
        Input: ResourcePatchModel,
        Model == Input.Model  {

            switch keyPathType {
            case .children(let relationKeyPath):
                return adding(PatchChildrenResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  childrenKeyPath: relationKeyPath))

            case .inversedChildren(let relationKeyPath):
                return adding(PatchParentResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  inversedChildrenKeyPath: relationKeyPath))
            }
    }

    func delete() -> RelatedResourceControllerBuilder  {

        switch keyPathType {
        case .children(let relationKeyPath):
            return adding(DeleteChildrenResourceController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relationNamePath: relationName,
                              childrenKeyPath: relationKeyPath))

        case .inversedChildren(let relationKeyPath):
            return adding(DeleteParentResourceController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relationNamePath: relationName,
                              inversedChildrenKeyPath: relationKeyPath))
        }
    }

    func collection<Sorting, Filtering>(sorting: Sorting.Type,
                                        filtering: Filtering.Type,
                                        config: IterableControllerConfig = .defaultConfig) -> RelatedResourceControllerBuilder
        where
        Sorting: SortProvider,
        Sorting.Model == Model,
        Filtering: FilterProvider,
        Filtering.Model == Model {

            switch keyPathType {
            case .children(let relationKeyPath):
                return adding(CollectionChildResourceController<Model,
                    RelatedModel,
                    Output,
                    Sorting,
                    EagerLoading,
                    Filtering>(relationNamePath: relationName,
                               childrenKeyPath: relationKeyPath,
                               config: config))

            case .inversedChildren(let relationKeyPath):
                return adding(CollectionParentResourceController<Model,
                    RelatedModel,
                    Output,
                    Sorting,
                    EagerLoading,
                    Filtering>(relationNamePath: relationName,
                               inversedChildrenKeyPath: relationKeyPath,
                               config: config))
            }
    }
}

public extension RelatedResourceControllerBuilder where RelatedModel: Authenticatable {
    func create<Input>(with: Input.Type, authenticatable: RelatedModel.Type) -> RelatedResourceControllerBuilder
        where
        Input: ResourceUpdateModel,
        Model == Input.Model  {

            switch keyPathType {
            case .children(let relationKeyPath):
                return adding(CreateAuthChildrenResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  childrenKeyPath: relationKeyPath))

            case .inversedChildren(let relationKeyPath):
                return adding(CreateAuthParentResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  inversedChildrenKeyPath: relationKeyPath))
            }
    }

    func read() -> RelatedResourceControllerBuilder {
            switch keyPathType {
            case .children(let relationKeyPath):
                return adding(ReadAuthChildrenResourceController<Model,
                    RelatedModel,
                    Output,
                    EagerLoading>(relationNamePath: relationName,
                                  childrenKeyPath: relationKeyPath))

            case .inversedChildren(let relationKeyPath):
                return adding(ReadAuthParentResourceController<Model,
                    RelatedModel,
                    Output,
                    EagerLoading>(relationNamePath: relationName,
                                  inversedChildrenKeyPath: relationKeyPath))
            }
    }

    func update<Input>(with: Input.Type, authenticatable: RelatedModel.Type) -> RelatedResourceControllerBuilder
        where
        Input: ResourceUpdateModel,
        Model == Input.Model  {

            switch keyPathType {
            case .children(let relationKeyPath):
                return adding(UpdateAuthChildrenResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  childrenKeyPath: relationKeyPath))

            case .inversedChildren(let relationKeyPath):
                return adding(UpdateAuthParentResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  inversedChildrenKeyPath: relationKeyPath))
            }
    }

    func patch<Input>(with: Input.Type, authenticatable: RelatedModel.Type) -> RelatedResourceControllerBuilder
        where
        Input: ResourcePatchModel,
        Model == Input.Model  {

            switch keyPathType {
            case .children(let relationKeyPath):
                return adding(PatchAuthChildrenResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  childrenKeyPath: relationKeyPath))

            case .inversedChildren(let relationKeyPath):
                return adding(PatchParentResourceController<Model,
                    RelatedModel,
                    Output, Input,
                    EagerLoading>(relationNamePath: relationName,
                                  inversedChildrenKeyPath: relationKeyPath))
            }
    }

    func delete(authenticatable: RelatedModel.Type) -> RelatedResourceControllerBuilder  {
        switch keyPathType {
        case .children(let relationKeyPath):
            return adding(DeleteAuthChildrenResourceController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relationNamePath: relationName,
                              childrenKeyPath: relationKeyPath))

        case .inversedChildren(let relationKeyPath):
            return adding(DeleteAuthParentResourceController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relationNamePath: relationName,
                              inversedChildrenKeyPath: relationKeyPath))
        }
    }

    func collection<Sorting, Filtering>(authenticatable: RelatedModel.Type,
                                        sorting: Sorting.Type,
                                        filtering: Filtering.Type,
                                        config: IterableControllerConfig = .defaultConfig) -> RelatedResourceControllerBuilder
        where
        Sorting: SortProvider,
        Sorting.Model == Model,
        Filtering: FilterProvider,
        Filtering.Model == Model {

            switch keyPathType {
            case .children(let relationKeyPath):
                return adding(CollectionAuthChildResourceController<Model,
                    RelatedModel,
                    Output,
                    Sorting,
                    EagerLoading,
                    Filtering>(relationNamePath: relationName,
                               childrenKeyPath: relationKeyPath,
                               config: config))

            case .inversedChildren(let relationKeyPath):
                return adding(CollectionAuthParentResourceController<Model,
                    RelatedModel,
                    Output,
                    Sorting,
                    EagerLoading,
                    Filtering>(relationNamePath: relationName,
                               inversedChildrenKeyPath: relationKeyPath,
                               config: config))
            }
    }
}
