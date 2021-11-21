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

extension BaseVaporRestKitTest {
    func routes() throws {
        app.group("v1") { base in

            base.group("stars") {
                let controller = StarControllersV2.StarController()

                $0.on(.POST, use: controller.create)
                $0.on(.GET, Star.idPath, use: controller.read)
                $0.on(.PUT, Star.idPath, use: controller.update)
                $0.on(.PATCH, Star.idPath, use: controller.patch)
                $0.on(.DELETE, Star.idPath, use: controller.delete)
                $0.on(.GET, use: controller.index)

                $0.group(Star.idPath, "belongs") {
                    $0.group("galaxies") {
                        let controller = GalaxyControllersV2.GalaxyForStarsNestedController()

                        $0.on(.POST, use: controller.create)
                        $0.on(.GET, Galaxy.idPath, use: controller.read)
                        $0.on(.PUT, Galaxy.idPath, use: controller.update)
                        $0.on(.PATCH, Galaxy.idPath, use: controller.patch)
                        $0.on(.DELETE, Galaxy.idPath, use: controller.delete)
                        $0.on(.GET, use: controller.index)

                        $0.group(Galaxy.idPath, "relation") {
                            let controller = GalaxyControllersV2.GalaxyForStarsRelationNestedController()

                            $0.on(.POST, use: controller.createRelation)
                            $0.on(.DELETE, use: controller.deleteRelation)
                        }
                    }

                    $0.group("ext_galaxies") {
                        let controller = GalaxyControllersV2.ExtendableGalaxyForStarsNestedController()

                        $0.on(.POST, use: controller.create)
                        $0.on(.GET, Galaxy.idPath, use: controller.read)
                        $0.on(.PUT, Galaxy.idPath, use: controller.update)
                        $0.on(.PATCH, Galaxy.idPath, use: controller.patch)
                        $0.on(.DELETE, Galaxy.idPath, use: controller.delete)
                        $0.on(.GET, use: controller.index)
                    }
                }

                $0.group(Star.idPath, "related", "star_tags") {
                    let controller = StarTagControllersV2.StarTagForStarNestedController()

                    $0.on(.POST, use: controller.create)
                    $0.on(.GET, StarTag.idPath, use: controller.read)
                    $0.on(.PUT, StarTag.idPath, use: controller.update)
                    $0.on(.PATCH, StarTag.idPath, use: controller.patch)
                    $0.on(.DELETE, StarTag.idPath, use: controller.delete)
                    $0.on(.GET, use: controller.index)

                    $0.group(StarTag.idPath, "relation") {
                        let controller = StarTagControllersV2.StarTagForStarRelationNestedController()

                        $0.on(.POST, use: controller.createRelation)
                        $0.on(.DELETE, use: controller.deleteRelation)
                    }
                }
            }

            base.group("ext_stars") {
                let controller = StarControllersV2.ExtendableStarController()

                $0.on(.POST, use: controller.create)
                $0.on(.GET, Star.idPath, use: controller.read)
                $0.on(.PUT, Star.idPath, use: controller.update)
                $0.on(.PATCH, Star.idPath, use: controller.patch)
                $0.on(.DELETE, Star.idPath, use: controller.delete)
                $0.on(.GET, use: controller.index)
            }

            base.group("full_stars") {
                let controller = StarControllersV2.FullStarController()

                $0.on(.POST, use: controller.create)
                $0.on(.GET, Star.idPath, use: controller.read)
                $0.on(.PUT, Star.idPath, use: controller.update)
                $0.on(.PATCH, Star.idPath, use: controller.patch)
                $0.on(.DELETE, Star.idPath, use: controller.delete)
                $0.on(.GET, use: controller.index)
            }

            base.group("d_stars") {
                let controller = StarControllersV2.DynamicStarController()

                $0.on(.POST, use: controller.create)
                $0.on(.GET, Star.idPath, use: controller.read)
                $0.on(.PUT, Star.idPath, use: controller.update)
                $0.on(.PATCH, Star.idPath, use: controller.patch)
                $0.on(.DELETE, Star.idPath, use: controller.delete)
                $0.on(.GET, use: controller.index)
            }

            base.group("galaxies") {
                let controller = GalaxyControllersV2.GalaxyController()

                $0.on(.POST, use: controller.create)
                $0.on(.GET, Galaxy.idPath, use: controller.read)
                $0.on(.PUT, Galaxy.idPath, use: controller.update)
                $0.on(.PATCH, Galaxy.idPath, use: controller.patch)
                $0.on(.DELETE, Galaxy.idPath, use: controller.delete)
                $0.on(.GET, use: controller.index)

                $0.group(Galaxy.idPath, "contains") {
                    $0.group("stars") {
                        let controller = StarControllersV2.StarForGalaxyNestedController()

                        $0.on(.POST, use: controller.create)
                        $0.on(.GET, Star.idPath, use: controller.read)
                        $0.on(.PUT, Star.idPath, use: controller.update)
                        $0.on(.PATCH, Star.idPath, use: controller.patch)
                        $0.on(.DELETE, Star.idPath, use: controller.delete)
                        $0.on(.GET, use: controller.index)

                        $0.group(Star.idPath, "relation") {
                            let controller = StarControllersV2.StarForGalaxyRelationNestedController()

                            $0.on(.POST, use: controller.createRelation)
                            $0.on(.DELETE, use: controller.deleteRelation)
                        }
                    }

                    $0.group("ext_stars") {
                        let controller = StarControllersV2.ExtendableStarForGalaxyNestedController()

                        $0.on(.POST, use: controller.create)
                        $0.on(.GET, Star.idPath, use: controller.read)
                        $0.on(.PUT, Star.idPath, use: controller.update)
                        $0.on(.PATCH, Star.idPath, use: controller.patch)
                        $0.on(.DELETE, Star.idPath, use: controller.delete)
                        $0.on(.GET, use: controller.index)
                    }

                    $0.group("full_stars") {
                        let controller = StarControllersV2.FullStarForGalaxyNestedController()

                        $0.on(.POST, use: controller.create)
                        $0.on(.GET, Star.idPath, use: controller.read)
                        $0.on(.PUT, Star.idPath, use: controller.update)
                        $0.on(.PATCH, Star.idPath, use: controller.patch)
                        $0.on(.DELETE, Star.idPath, use: controller.delete)
                        $0.on(.GET, use: controller.index)
                    }

                    $0.group("d_stars") {
                        let controller = StarControllersV2.DynamicStarForGalaxyNestedController()

                        $0.on(.POST, use: controller.create)
                        $0.on(.GET, Star.idPath, use: controller.read)
                        $0.on(.PUT, Star.idPath, use: controller.update)
                        $0.on(.PATCH, Star.idPath, use: controller.patch)
                        $0.on(.DELETE, Star.idPath, use: controller.delete)
                        $0.on(.GET, use: controller.index)
                    }
                }
            }

            base.group("star_tags") {
                let controller = StarTagControllersV2.StarTagController()

                $0.on(.POST, use: controller.create)
                $0.on(.GET, StarTag.idPath, use: controller.read)
                $0.on(.PUT, StarTag.idPath, use: controller.update)
                $0.on(.PATCH, StarTag.idPath, use: controller.patch)
                $0.on(.DELETE, StarTag.idPath, use: controller.delete)
                $0.on(.GET, use: controller.index)

                $0.group(StarTag.idPath, "related") {
                    $0.group("stars") {
                        let controller = StarControllersV2.StarForTagsNestedController()

                        $0.on(.POST, use: controller.create)
                        $0.on(.GET, Star.idPath, use: controller.read)
                        $0.on(.PUT, Star.idPath, use: controller.update)
                        $0.on(.PATCH, Star.idPath, use: controller.patch)
                        $0.on(.DELETE, Star.idPath, use: controller.delete)
                        $0.on(.GET, use: controller.index)

                        $0.group(Star.idPath, "relation") {
                            let controller = StarControllersV2.StarForTagsRelationNestedController()

                            $0.on(.POST, use: controller.createRelation)
                            $0.on(.DELETE, use: controller.deleteRelation)
                        }
                    }

                    $0.group("ext_stars") {
                        let controller = StarControllersV2.ExtendableStarForTagsNestedController()

                        $0.on(.POST, use: controller.create)
                        $0.on(.GET, Star.idPath, use: controller.read)
                        $0.on(.PUT, Star.idPath, use: controller.update)
                        $0.on(.PATCH, Star.idPath, use: controller.patch)
                        $0.on(.DELETE, Star.idPath, use: controller.delete)
                        $0.on(.GET, use: controller.index)
                    }

                    $0.group("full_stars") {
                        let controller = StarControllersV2.FullStarForTagsNestedController()

                        $0.on(.POST, use: controller.create)
                        $0.on(.GET, Star.idPath, use: controller.read)
                        $0.on(.PUT, Star.idPath, use: controller.update)
                        $0.on(.PATCH, Star.idPath, use: controller.patch)
                        $0.on(.DELETE, Star.idPath, use: controller.delete)
                        $0.on(.GET, use: controller.index)
                    }

                    $0.group("d_stars") {
                        let controller = StarControllersV2.DynamicStarForTagsNestedController()

                        $0.on(.POST, use: controller.create)
                        $0.on(.GET, Star.idPath, use: controller.read)
                        $0.on(.PUT, Star.idPath, use: controller.update)
                        $0.on(.PATCH, Star.idPath, use: controller.patch)
                        $0.on(.DELETE, Star.idPath, use: controller.delete)
                        $0.on(.GET, use: controller.index)
                    }
                }

            }

            base.group("planets") {
                $0.group(Planet.idPath, "refers", "stars") {
                    let controller = StarControllersV2.StarForPlanetNestedController()

                    $0.on(.POST, use: controller.create)
                    $0.on(.GET, Star.idPath, use: controller.read)
                    $0.on(.PUT, Star.idPath, use: controller.update)
                    $0.on(.PATCH, Star.idPath, use: controller.patch)
                    $0.on(.DELETE, Star.idPath, use: controller.delete)
                    $0.on(.GET, use: controller.index)
                }
            }

            base.group("todos") {
                let controller = TodoControllersV2.TodoController()

                $0.on(.POST, use: controller.create)
                $0.on(.GET, Todo.idPath, use: controller.read)
                $0.on(.GET, use: controller.index)

                $0.group(Todo.idPath, "assignees", "users") {
                    let controller = UserControllersV2.UsersForTodoController()

                    $0.on(.GET, User.idPath, use: controller.read)
                    $0.on(.GET, use: controller.index)

                    $0.grouped(MockAuthenticator<User>(userId: 1), User.guardMiddleware())
                        .group(User.idPath, "relation") {
                            let controller = UserControllersV2.TodoAssigneesRelationController()

                            $0.on(.POST, use: controller.addAssignee)
                            $0.on(.DELETE, use: controller.removeAssignee)
                        }
                }

                $0.group(Todo.idPath, "tags") {
                    let controller = TagControllersV2.TagsForTodoController()

                    $0.on(.POST, use: controller.create)
                    $0.on(.GET, Tag.idPath, use: controller.read)
                    $0.on(.PUT, Tag.idPath, use: controller.update)
                    $0.on(.PATCH, Tag.idPath, use: controller.patch)
                    $0.on(.GET, use: controller.index)
                }
            }

            base.group("users") {
                let controller = UserControllersV2.UsersController()

                $0.on(.POST, use: controller.create)
                $0.on(.GET, User.idPath, use: controller.read)

                $0.group(User.idPath, "assigned", "todos") {
                    let controller = TodoControllersV2.AssignedTodosForUserController()

                    $0.on(.GET, Todo.idPath, use: controller.read)
                    $0.on(.GET, use: controller.index)
                }

                $0.group(User.idPath, "owns","todos") {
                    let controller = TodoControllersV2.TodosForUserController()

                    $0.on(.GET, Todo.idPath, use: controller.read)
                    $0.on(.GET, use: controller.index)
                }

                let auth = $0.grouped(MockAuthenticator<User>(userId: 1), User.guardMiddleware())
                auth.group("me", "owns", "todos") {
                    let controller = TodoControllersV2.MyTodosController()

                    $0.on(.POST, use: controller.create)
                    $0.on(.GET, Todo.idPath, use: controller.read)
                    $0.on(.PUT, Todo.idPath, use: controller.update)
                    $0.on(.PATCH, Todo.idPath, use: controller.patch)
                    $0.on(.DELETE, Todo.idPath, use: controller.delete)
                    $0.on(.GET, use: controller.index)

                    $0.group(Todo.idPath, "relation") {
                        let controller = TodoControllersV2.MyTodosRelationController()

                        $0.on(.POST, use: controller.createRelation)
                        $0.on(.DELETE, use: controller.deleteRelation)
                    }
                }

                auth.group("me", "assigned", "todos") {
                    let controller = TodoControllersV2.MyAssignedTodosForUserController()

                    $0.on(.GET, Todo.idPath, use: controller.read)
                    $0.on(.GET, use: controller.index)

                    $0.group(Todo.idPath, "relation") {
                        let controller = TodoControllersV2.MyAssignedTodosForUserRelationController()

                        $0.on(.POST, use: controller.createRelation)
                        $0.on(.DELETE, use: controller.deleteRelation)
                    }
                }

                auth.group("me", "referred", "referral_codes") {
                    let controller = ReferralCodeControllersV2.ReferralCodeForUserController()

                    $0.on(.POST, use: controller.create)
                    $0.on(.GET, ReferralCode.idPath, use: controller.read)
                    $0.on(.PUT, ReferralCode.idPath, use: controller.update)
                    $0.on(.PATCH, ReferralCode.idPath, use: controller.patch)
                    $0.on(.DELETE, ReferralCode.idPath, use: controller.delete)

                    $0.group(ReferralCode.idPath, "relation") {
                        let controller = ReferralCodeControllersV2.ReferralCodeForUserRelationController()

                        $0.on(.POST, use: controller.createRelation)
                        $0.on(.DELETE, use: controller.deleteRelation)
                    }
                }
            }

            base.group("tags") {
                let controller = TagControllersV2.TagController()

                $0.on(.GET, use: controller.index)

                $0.group(Tag.idPath, "related", "todos") {
                    let controller = TodoControllersV2.TodosForTagsController()

                    $0.on(.GET, Todo.idPath, use: controller.read)
                    $0.on(.GET, use: controller.index)

                    $0.group(Todo.idPath, "relation") {
                        let controller = TodoControllersV2.TodosForTagsRelationController()

                        $0.on(.POST, use: controller.createRelation)
                        $0.on(.DELETE, use: controller.deleteRelation)
                    }

                }
            }

            base.group("referral_codes") {
                let controller = ReferralCodeControllersV2.ReferralCodeController()

                $0.on(.POST, use: controller.create)
                $0.on(.GET, ReferralCode.idPath, use: controller.read)
                $0.on(.PUT, ReferralCode.idPath, use: controller.update)
                $0.on(.PATCH, ReferralCode.idPath, use: controller.patch)
                $0.on(.DELETE, ReferralCode.idPath, use: controller.delete)
            }
        }
    }
}
