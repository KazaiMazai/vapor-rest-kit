//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 09.06.2020.
//

@testable import VaporRestKit
import XCTVapor

final class AuthParentChildCreateDeleteRelationTests: BaseVaporRestKitTest {
    func testCreateWithValidDataAndDelete() throws {
        try routes()

        try app.test(.GET, "v1/users/1") { res in
            XCTAssertEqual(res.status, .notFound)
        }.test(.GET, "v1/todos/1") { res in
            XCTAssertEqual(res.status, .notFound)

        }.test(.POST, "v1/users", body: User.Input(username: "John Doe", age: 40)) { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(User.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.username, "John Doe")
                XCTAssertEqual($0.age, 40)
            }
        }.test(.GET, "v1/users/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(User.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.username, "John Doe")
                XCTAssertEqual($0.age, 40)
            }
        }.test(.POST, "v1/todos", body: Todo.Input(title: "Clean Up")) { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Todo.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Clean Up")
            }
        }.test(.GET, "v1/todos/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Todo.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Clean Up")
            }
        }.test(.POST, "v1/users/me/owns/todos/1/relation") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Todo.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Clean Up")
            }
        }.test(.GET, "v1/users/me/owns/todos/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Todo.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Clean Up")
            }

        }.test(.GET, "v1/users/1/owns/todos/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Todo.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Clean Up")
            }

        }.test(.DELETE, "v1/users/me/owns/todos/1/relation") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Todo.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Clean Up")
            }
        }.test(.GET, "v1/users/me/owns/todos/1") { res in
            XCTAssertEqual(res.status, .notFound)

        }.test(.GET, "v1/users/1/owns/todos/1") { res in
            XCTAssertEqual(res.status, .notFound)

        }.test(.GET, "v1/users/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(User.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.username, "John Doe")
                XCTAssertEqual($0.age, 40)
            }
        }.test(.GET, "v1/todos/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Todo.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Clean Up")
            }
        }
    }
}


final class AuthParentChildCreateDeleteRelationDeprecatedAPITests: BaseVaporRestKitDeprecatedAPITest {
    func testCreateWithValidDataAndDelete() throws {
        try routes()

        try app.test(.GET, "v1/users/1") { res in
            XCTAssertEqual(res.status, .notFound)
        }.test(.GET, "v1/todos/1") { res in
            XCTAssertEqual(res.status, .notFound)

        }.test(.POST, "v1/users", body: User.Input(username: "John Doe", age: 40)) { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(User.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.username, "John Doe")
                XCTAssertEqual($0.age, 40)
            }
        }.test(.GET, "v1/users/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(User.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.username, "John Doe")
                XCTAssertEqual($0.age, 40)
            }
        }.test(.POST, "v1/todos", body: Todo.Input(title: "Clean Up")) { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Todo.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Clean Up")
            }
        }.test(.GET, "v1/todos/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Todo.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Clean Up")
            }
        }.test(.POST, "v1/users/me/owns/todos/1/relation") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Todo.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Clean Up")
            }
        }.test(.GET, "v1/users/me/owns/todos/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Todo.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Clean Up")
            }

        }.test(.GET, "v1/users/1/owns/todos/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Todo.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Clean Up")
            }

        }.test(.DELETE, "v1/users/me/owns/todos/1/relation") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Todo.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Clean Up")
            }
        }.test(.GET, "v1/users/me/owns/todos/1") { res in
            XCTAssertEqual(res.status, .notFound)

        }.test(.GET, "v1/users/1/owns/todos/1") { res in
            XCTAssertEqual(res.status, .notFound)

        }.test(.GET, "v1/users/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(User.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.username, "John Doe")
                XCTAssertEqual($0.age, 40)
            }
        }.test(.GET, "v1/todos/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Todo.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Clean Up")
            }
        }
    }
}
