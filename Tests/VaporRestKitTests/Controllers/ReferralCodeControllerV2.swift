//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 15.08.2021.
//

import Foundation

@testable import VaporRestKit
import XCTVapor
import Vapor
import Fluent


struct ReferralCodeControllersV2 {
    struct ReferralCodeController {

        func create(req: Request) throws -> EventLoopFuture<ReferralCode.Output> {
            try ResourceController<ReferralCode>().create(
                req: req,
                using: ReferralCode.Input.self)
        }

        func read(req: Request) throws -> EventLoopFuture<ReferralCode.Output> {
            try ResourceController<ReferralCode>().read(
                req: req,
                queryModifier: .empty)
        }

        func update(req: Request) throws -> EventLoopFuture<ReferralCode.Output> {
            try ResourceController<ReferralCode>().update(
                req: req,
                using: ReferralCode.Input.self,
                queryModifier: .empty)
        }

        func delete(req: Request) throws -> EventLoopFuture<ReferralCode.Output> {
            try ResourceController<ReferralCode>().delete(
                req: req,
                using: .defaultDeleter,
                queryModifier: .empty)
        }

        func patch(req: Request) throws -> EventLoopFuture<ReferralCode.Output> {
            try ResourceController<ReferralCode>().patch(
                req: req,
                using: ReferralCode.PatchInput.self,
                queryModifier: .empty)
        }
    }

    struct ReferralCodeForUserController {
        func create(req: Request) throws -> EventLoopFuture<ReferralCode.Output> {
            try RelatedResourceController<ReferralCode>().create(
                resolver: .requireAuth(),
                req: req,
                using: ReferralCode.Input.self,
                relationKeyPath: \ReferralCode.$users)
        }

        func read(req: Request) throws -> EventLoopFuture<ReferralCode.Output> {
            try RelatedResourceController<ReferralCode>().read(
                resolver: .requireAuth(),
                req: req,
                queryModifier: .empty,
                relationKeyPath: \ReferralCode.$users)
        }

        func update(req: Request) throws -> EventLoopFuture<ReferralCode.Output> {
            try RelatedResourceController<ReferralCode>().update(
                resolver: .requireAuth(),
                req: req,
                using: ReferralCode.Input.self,
                queryModifier: .empty,
                relationKeyPath: \ReferralCode.$users)
        }

        func delete(req: Request) throws -> EventLoopFuture<ReferralCode.Output> {
            try RelatedResourceController<ReferralCode>().delete(
                resolver: .requireAuth(),
                req: req,
                using: .defaultDeleter,
                queryModifier: .empty,
                relationKeyPath: \ReferralCode.$users)
        }

        func patch(req: Request) throws -> EventLoopFuture<ReferralCode.Output> {
            try RelatedResourceController<ReferralCode>().patch(
                resolver: .requireAuth(),
                req: req,
                using: ReferralCode.PatchInput.self,
                queryModifier: .empty,
                relationKeyPath: \ReferralCode.$users)
        }
    }

    struct ReferralCodeForUserRelationController {
        func createRelation(req: Request) throws -> EventLoopFuture<ReferralCode.Output> {
            try RelationsController<ReferralCode>().createRelation(
                resolver: .requireAuth(),
                req: req,
                queryModifier: .empty,
                relationKeyPath: \ReferralCode.$users)
        }

        func deleteRelation(req: Request) throws -> EventLoopFuture<ReferralCode.Output> {
            try RelationsController<ReferralCode>().deleteRelation(
                resolver: .requireAuth(),
                req: req,
                queryModifier: .empty,
                relationKeyPath: \ReferralCode.$users)
        }
    }
}
