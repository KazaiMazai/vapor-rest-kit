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
        let v1 = CompoundResourceController(with:[
            User.Output
                .resourceController(eagerLoading: EagerLoadingUnsupported.self)
                .create(input: User.Input.self),

            User.Output
                .resourceController(eagerLoading: EagerLoadingUnsupported.self)
                .read(),

            User.Output
                .resourceController(eagerLoading: EagerLoadingUnsupported.self)
                .update(input: User.Input.self),

            User.Output
                .resourceController(eagerLoading: EagerLoadingUnsupported.self)
                .patch(input: User.PatchInput.self),

            User.Output.resourceController(eagerLoading: EagerLoadingUnsupported.self)
                .delete(),

            User.Output
                .resourceController(eagerLoading: EagerLoadingUnsupported.self)
                .collection(sorting: SortingUnsupported.self, filtering: FilteringUnsupported.self)

        ])

        let v2 = CompoundResourceController(with:[
            User.OutputV2
                .resourceController(eagerLoading: EagerLoadingUnsupported.self)
                .read(),

            User.OutputV2
                .resourceController(eagerLoading: EagerLoadingUnsupported.self)
                .collection(sorting: SortingUnsupported.self, filtering: FilteringUnsupported.self)



        ])


        func setupAPIMethods(on routeBuilder: RoutesBuilder, for endpoint: String, with version: ApiVersion) {
            switch version {
            case .v1:
                v1.addMethodsTo(routeBuilder, on: endpoint)
            case .v2:
                v2.addMethodsTo(routeBuilder, on: endpoint)
            }
        }
    }
}
