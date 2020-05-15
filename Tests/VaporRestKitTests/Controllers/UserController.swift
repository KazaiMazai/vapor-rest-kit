//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 15.05.2020.
//

@testable import VaporRestKit
import XCTVapor
import Vapor
import Fluent

struct UserControllers {
    struct AllUsersController: VersionableController {
        var v1: APIMethodsProviding {
            return User.Output
                .resourceController(eagerLoading: EagerLoadingUnsupported.self)
                .create(input: User.Input.self)
                .read()
                .update(input: User.Input.self)
                .patch(input: User.PatchInput.self)
                .delete()
                .collection(sorting: SortingUnsupported.self,
                            filtering: FilteringUnsupported.self)

        }

        var v2: APIMethodsProviding {
                   return User.Output
                       .resourceController(eagerLoading: EagerLoadingUnsupported.self)
                        .relatedTo(relation: \Todo.$assignees, relationName: "assignees")
                       .create(input: User.Input.self)
                       .read()
                       .update(input: User.Input.self)
                       .patch(input: User.PatchInput.self)
                       .delete()
                       .collection(sorting: SortingUnsupported.self,
                                   filtering: FilteringUnsupported.self)

               }


        //        let v2 = CompoundResourceController(with:[
        //            User.OutputV2
        //                .resourceController(eagerLoading: EagerLoadingUnsupported.self)
        //                .read(),
        //
        //            User.OutputV2
        //                .resourceController(eagerLoading: EagerLoadingUnsupported.self)
        //                .collection(sorting: SortingUnsupported.self, filtering: FilteringUnsupported.self)
        //
        //
        //
        //        ])


        func setupAPIMethods(on routeBuilder: RoutesBuilder, for endpoint: String, with version: ApiVersion) {
            switch version {
            case .v1:
                v1.addMethodsTo(routeBuilder, on: endpoint)
            case .v2:
                v1.addMethodsTo(routeBuilder, on: endpoint)
            }
        }
    }
}
