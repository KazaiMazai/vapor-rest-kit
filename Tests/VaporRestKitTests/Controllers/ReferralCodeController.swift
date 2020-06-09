//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 09.06.2020.
//

@testable import VaporRestKit
import XCTVapor
import Vapor
import Fluent


struct ReferralCodeControllers {
    struct ReferralCodeController: VersionableController {
        var apiV1: APIMethodsProviding {
            return ReferralCode.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .create(using: ReferralCode.Input.self)
                .read()
                .update(using: ReferralCode.Input.self)
                .patch(using: ReferralCode.PatchInput.self)
                .delete()
        }

        func setupAPIMethods(on routeBuilder: RoutesBuilder, for endpoint: String, with version: ApiVersion) {
            switch version {
            case .v1:
                apiV1.addMethodsTo(routeBuilder, on: endpoint)
            }
        }
    }

    struct ReferralCodeForUserController: VersionableController {
        var apiV1: APIMethodsProviding {
            return ReferralCode.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .related(by: \ReferralCode.$users, relationName: "referred")
                .create(using: ReferralCode.Input.self, authenticatable: User.self)
                .read(authenticatable: User.self)
                .update(using: ReferralCode.Input.self, authenticatable: User.self)
                .patch(using: ReferralCode.PatchInput.self, authenticatable: User.self)
                .delete(authenticatable: User.self)
        }

        func setupAPIMethods(on routeBuilder: RoutesBuilder, for endpoint: String, with version: ApiVersion) {
            switch version {
            case .v1:
                apiV1.addMethodsTo(routeBuilder, on: endpoint)
            }
        }
    }

    struct ReferralCodeForUserRelationController: VersionableController {
        var apiV1: APIMethodsProviding {
            return ReferralCode.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .related(by: \ReferralCode.$users, relationName: "referred")
                .relation
                .create(authenticatable: User.self)
                .delete(authenticatable: User.self)
        }

        func setupAPIMethods(on routeBuilder: RoutesBuilder, for endpoint: String, with version: ApiVersion) {
            switch version {
            case .v1:
                apiV1.addMethodsTo(routeBuilder, on: endpoint)
            }
        }
    }
}
