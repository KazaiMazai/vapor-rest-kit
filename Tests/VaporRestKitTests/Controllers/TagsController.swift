//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 18.05.2020.
//

@testable import VaporRestKit
import XCTVapor
import Vapor
import Fluent

struct TagControllers {
    struct TagController: VersionableController {
        var controller: APIMethodsProviding {
            return Tag.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .related(with: \Todo.$tags, relationName: "mentioned")
                .create(input: Tag.CreateInput.self)
                .read()
                .update(input: Tag.UpdateInput.self)
                .patch(input: Tag.PatchInput.self)
                .collection(sorting: SortingUnsupported.self,
                            filtering: FilteringUnsupported.self)
        }




        func setupAPIMethods(on routeBuilder: RoutesBuilder, for endpoint: String, with version: ApiVersion) {
            switch version {
            case .v1, .v2:
                let todos = routeBuilder.grouped("todos")
                 controller.addMethodsTo(todos, on: endpoint)
            }
        }
    }
}
