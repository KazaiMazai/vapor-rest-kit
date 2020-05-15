//
//  
//  
//
//  Created by Sergey Kazakov on 15.05.2020.
//

import Vapor
import Fluent

public struct ResourceControllerFactory<Model, Output, EagerLoading>
    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model {

    internal init<Model, Output, EagerLoading>(modelType: Model.Type = Model.self,
                                      outputType: Output.Type = Output.self,
                                      eagerLoading: EagerLoading.Type = EagerLoading.self) {

    }
}

public extension ResourceControllerFactory {
    func relatedTo<RelatedModel, Through>(relation: SiblingKeyPath<RelatedModel, Model, Through>,
                                          relationName: String) -> SiblingsResourceControllerFactory<Model,
        RelatedModel,
        Through,
        Output,
        EagerLoading> {

            return SiblingsResourceControllerFactory<Model,
                RelatedModel,
                Through,
                Output,
                EagerLoading>(self,
                              relation: relation,
                              relationName: relationName)
    }

    func relatedTo<RelatedModel>(_ childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>,
                                 relationName: String) -> RelatedResourceControllerFactory<Model, RelatedModel, Output, EagerLoading> {

        return RelatedResourceControllerFactory<Model, RelatedModel, Output, EagerLoading>(self,
                                                                                           childrenKeyPath: childrenKeyPath,
                                                                                           relationName: relationName)
    }

    func relatedTo<RelatedModel>(_ childrenKeyPath: ChildrenKeyPath<Model, RelatedModel>,
                                 relationName: String) -> RelatedResourceControllerFactory<Model, RelatedModel, Output, EagerLoading> {

        return RelatedResourceControllerFactory<Model,
            RelatedModel,
            Output,
            EagerLoading>(self,
                          childrenKeyPath: childrenKeyPath,
                          relationName: relationName)
    }
}


extension ResourceControllerFactory {
    func create<Input>(input: Input.Type) -> APIMethodsProviding
        where
        Input: ResourceUpdateModel,
        Model == Input.Model {

            return CreateResourceController<Model,
                Output,
                Input,
                EagerLoading>()
    }

    func read() -> APIMethodsProviding {
        return ReadResourceController<Model,
            Output,
            EagerLoading>()
    }

    func update<Input>(input: Input.Type) -> APIMethodsProviding
        where
        Input: ResourceUpdateModel,
        Model == Input.Model {

            return UpdateResourceController<Model,
                Output,
                Input,
                EagerLoading>()
    }

    func patch<Input>(input: Input.Type) -> APIMethodsProviding
        where
        Input: ResourcePatchModel,
        Model == Input.Model {

            return PatchResourceController<Model,
                Output,
                Input,
                EagerLoading>()
    }

    func delete() -> APIMethodsProviding {
        return DeleteResourceController<Model,
            Output,
            EagerLoading>()
    }

    func collection<Sorting, Filtering>(sorting: Sorting.Type,
                                        filtering: Filtering.Type,
                                        config: IterableControllerConfig = .defaultConfig) -> APIMethodsProviding
        where
        Sorting: SortProvider,
        Sorting.Model == Model,
        Filtering: FilterProvider,
        Filtering.Model == Model {

            return CollectionResourceController<Model,
                Output,
                Sorting,
                EagerLoading,
                Filtering>(config: config)
    }
}

