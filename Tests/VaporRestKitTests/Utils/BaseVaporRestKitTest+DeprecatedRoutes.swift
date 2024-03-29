//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 22.08.2021.
//

@testable import VaporRestKit
import XCTVapor
import Vapor
import Fluent
import FluentSQLiteDriver


class BaseVaporRestKitDeprecatedAPITest: BaseVaporRestKitTest {
    override func routes() throws {
        try routesWithDeprecatedAPI()
    }
}

extension BaseVaporRestKitDeprecatedAPITest {
    func routesWithDeprecatedAPI() throws {
        ApiVersion.allCases.forEach { version in
            let versiondGroup = app.grouped(version.path)

            app.group(version.path) {
                StarTagControllers.StarTagController().setupAPIMethods(on: $0, for: "star_tags", with: version)
            }

            StarTagControllers.StarTagController().setupAPIMethods(on: versiondGroup, for: "star_tags", with: version)

            StarControllers.StarController().setupAPIMethods(on: versiondGroup, for: "stars", with: version)
            StarControllers.ExtendableStarController().setupAPIMethods(on: versiondGroup, for: "ext_stars", with: version)
            StarControllers.FullStarController().setupAPIMethods(on: versiondGroup, for: "full_stars", with: version)
            StarControllers.DynamicStarController().setupAPIMethods(on: versiondGroup, for: "d_stars", with: version)

            GalaxyControllers.GalaxyController().setupAPIMethods(on: versiondGroup, for: "galaxies", with: version)

            let galaxyGroup = versiondGroup.grouped("galaxies")

            StarControllers.StarForGalaxyNestedController().setupAPIMethods(on: galaxyGroup, for: "stars", with: version)
            StarControllers.ExtendableStarForGalaxyNestedController().setupAPIMethods(on: galaxyGroup, for: "ext_stars", with: version)
            StarControllers.FullStarForGalaxyNestedController().setupAPIMethods(on: galaxyGroup, for: "full_stars", with: version)
            StarControllers.DynamicStarForGalaxyNestedController().setupAPIMethods(on: galaxyGroup, for: "d_stars", with: version)


            StarControllers.StarForGalaxyRelationNestedController().setupAPIMethods(on: galaxyGroup, for: "stars", with: version)

            let starTagGroup = versiondGroup.grouped("star_tags")

            StarControllers.StarForTagsNestedController().setupAPIMethods(on: starTagGroup, for: "stars", with: version)
            StarControllers.StarForTagsRelationNestedController().setupAPIMethods(on: starTagGroup, for: "stars", with: version)


            StarControllers.ExtendableStarForTagsNestedController().setupAPIMethods(on: starTagGroup, for: "ext_stars", with: version)
            StarControllers.FullStarForTagsNestedController().setupAPIMethods(on: starTagGroup, for: "full_stars", with: version)
            StarControllers.DynamicStarForTagsNestedController().setupAPIMethods(on: starTagGroup, for: "d_stars", with: version)

            let planetGroup = versiondGroup.grouped("planets")

            StarControllers.StarForPlanetNestedController().setupAPIMethods(on: planetGroup, for: "stars", with: version)

            let starGroup = versiondGroup.grouped("stars")

            GalaxyControllers.GalaxyForStarsNestedController().setupAPIMethods(on: starGroup, for: "galaxies", with: version)
            GalaxyControllers.GalaxyForStarsRelationNestedController().setupAPIMethods(on: starGroup, for: "galaxies", with: version)

            GalaxyControllers.ExtendableGalaxyForStarsNestedController().setupAPIMethods(on: starGroup, for: "ext_galaxies", with: version)


            StarTagControllers.StarTagForStarNestedController().setupAPIMethods(on: starGroup, for: "star_tags", with: version)
            StarTagControllers.StarTagForStarRelationNestedController().setupAPIMethods(on: starGroup, for: "star_tags", with: version)

            TodoControllers.TodoController().setupAPIMethods(on: versiondGroup, for: "todos", with: version)
            UserControllers.UsersController().setupAPIMethods(on: versiondGroup, for: "users", with: version)
            TagControllers.TagController().setupAPIMethods(on: versiondGroup, for: "tags", with: version)
            ReferralCodeControllers.ReferralCodeController().setupAPIMethods(on: versiondGroup, for: "referral_codes", with: version)

            let todosGroup = versiondGroup.grouped("todos")
            let authTodosGroup = todosGroup.grouped(MockAuthenticator<User>(userId: 1), User.guardMiddleware())
            UserControllers.UsersForTodoController().setupAPIMethods(on: todosGroup, for: "users", with: version)
            UserControllers.TodoAssigneesRelationController().setupAPIMethods(on: authTodosGroup, for: "users", with: version)
            TagControllers.TagsForTodoController().setupAPIMethods(on: todosGroup, for: "tags", with: version)

            let usersGroup = versiondGroup.grouped("users")
            TodoControllers.AssignedTodosForUserController().setupAPIMethods(on: usersGroup, for: "todos", with: version)



            TodoControllers.TodosForUserController().setupAPIMethods(on: usersGroup, for: "todos", with: version)

            let authUsersGroup = usersGroup.grouped(MockAuthenticator<User>(userId: 1), User.guardMiddleware())

            TodoControllers.MyTodosController().setupAPIMethods(on: authUsersGroup, for: "todos", with: version)
            TodoControllers.MyTodosRelationController().setupAPIMethods(on: authUsersGroup, for: "todos", with: version)
            TodoControllers.MyAssignedTodosForUserController().setupAPIMethods(on: authUsersGroup, for: "todos", with: version)
            TodoControllers.MyAssignedTodosForUserRelationController().setupAPIMethods(on: authUsersGroup, for: "todos", with: version)
            ReferralCodeControllers.ReferralCodeForUserController().setupAPIMethods(on: authUsersGroup, for: "referral_codes", with: version)
            ReferralCodeControllers.ReferralCodeForUserRelationController().setupAPIMethods(on: authUsersGroup, for: "referral_codes", with: version)



            let tagsGroup = versiondGroup.grouped("tags")
            TodoControllers.TodosForTagsController().setupAPIMethods(on: tagsGroup, for: "todos", with: version)
            TodoControllers.TodosForTagsRelationController().setupAPIMethods(on: tagsGroup, for: "todos", with: version)
        }
    }

}
