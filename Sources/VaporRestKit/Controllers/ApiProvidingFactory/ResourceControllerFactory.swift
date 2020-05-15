//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 15.05.2020.
//

import Vapor
import Fluent

struct ResourceControllerFactory<Model, Output, EagerLoading>
    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model {

    init<Model, Output, EagerLoading>(modelType: Model.Type = Model.self,
                                      outputType: Output.Type = Output.self,
                                      eagerLoading: EagerLoading.Type = EagerLoading.self) {

    }

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

    func relatedTo<RelatedModel>(_ child: ChildrenKeyPath<RelatedModel, Model>,
                                 relationName: String) -> RelatedResourceControllerFactory<Model, RelatedModel, Output, EagerLoading> {

        return RelatedResourceControllerFactory<Model, RelatedModel, Output, EagerLoading>(self,
                                                                                           child: child,
                                                                                           relationName: relationName)
    }

    func relatedTo<RelatedModel>(_ reversedChild: ChildrenKeyPath<Model, RelatedModel>,
                                 relationName: String) -> RelatedResourceControllerFactory<Model, RelatedModel, Output, EagerLoading> {

        return RelatedResourceControllerFactory<Model, RelatedModel, Output, EagerLoading>(self,
                                                                                           reversedChild: reversedChild,
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


    func collection<Sorting, Filtering>(sorting: Sorting.Type, filtering: Filtering.Type) -> APIMethodsProviding
        where
        Sorting: SortProvider,
        Sorting.Model == Model,
        Filtering: FilterProvider,
        Filtering.Model == Model {

        return CollectionResourceController<Model, Output, Sorting, EagerLoading, Filtering>()
    }
}

