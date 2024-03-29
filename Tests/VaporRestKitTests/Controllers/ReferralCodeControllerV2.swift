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
            try ResourceController<ReferralCode.Output>().create(
                req: req,
                using: ReferralCode.Input.self)
        }

        func read(req: Request) throws -> EventLoopFuture<ReferralCode.Output> {
            try ResourceController<ReferralCode.Output>().read(
                req: req)
        }

        func update(req: Request) throws -> EventLoopFuture<ReferralCode.Output> {
            try ResourceController<ReferralCode.Output>().update(
                req: req,
                using: ReferralCode.Input.self)
        }

        func delete(req: Request) throws -> EventLoopFuture<ReferralCode.Output> {
            try ResourceController<ReferralCode.Output>().delete(
                req: req)
        }

        func patch(req: Request) throws -> EventLoopFuture<ReferralCode.Output> {
            try ResourceController<ReferralCode.Output>().patch(
                req: req,
                using: ReferralCode.PatchInput.self)
        }
    }

    struct ReferralCodeForUserController {
        func create(req: Request) throws -> EventLoopFuture<ReferralCode.Output> {
            try RelatedResourceController<ReferralCode.Output>().create(
                resolver: .requireAuth(),
                req: req,
                using: ReferralCode.Input.self,
                relationKeyPath: \ReferralCode.$users)
        }

        func read(req: Request) throws -> EventLoopFuture<ReferralCode.Output> {
            try RelatedResourceController<ReferralCode.Output>().read(
                resolver: .requireAuth(),
                req: req,
                relationKeyPath: \ReferralCode.$users)
        }

        func update(req: Request) throws -> EventLoopFuture<ReferralCode.Output> {
            try RelatedResourceController<ReferralCode.Output>().update(
                resolver: .requireAuth(),
                req: req,
                using: ReferralCode.Input.self,
                relationKeyPath: \ReferralCode.$users)
        }

        func delete(req: Request) throws -> EventLoopFuture<ReferralCode.Output> {
            try RelatedResourceController<ReferralCode.Output>().delete(
                resolver: .requireAuth(),
                req: req,
                relationKeyPath: \ReferralCode.$users)
        }

        func patch(req: Request) throws -> EventLoopFuture<ReferralCode.Output> {
            try RelatedResourceController<ReferralCode.Output>().patch(
                resolver: .requireAuth(),
                req: req,
                using: ReferralCode.PatchInput.self,
                relationKeyPath: \ReferralCode.$users)
        }
    }

    struct ReferralCodeForUserRelationController {
        func createRelation(req: Request) throws -> EventLoopFuture<ReferralCode.Output> {
            try RelationsController<ReferralCode.Output>().createRelation(
                resolver: .requireAuth(),
                req: req,
                relationKeyPath: \ReferralCode.$users)
        }

        func deleteRelation(req: Request) throws -> EventLoopFuture<ReferralCode.Output> {
            try RelationsController<ReferralCode.Output>().deleteRelation(
                resolver: .requireAuth(),
                req: req,
                relationKeyPath: \ReferralCode.$users)
        }
    }
}
