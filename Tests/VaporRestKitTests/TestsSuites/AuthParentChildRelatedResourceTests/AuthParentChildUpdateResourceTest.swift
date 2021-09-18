//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 09.06.2020.
//


@testable import VaporRestKit
import XCTVapor

final class AuthParentChildUpdateResourceTests: BaseVaporRestKitTest {
    func testUpdateWithValidData() throws {
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
        }.test(.POST, "v1/users/me/owns/todos", body: Todo.Input(title: "Clean Up")) { res in
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

        }.test(.PUT, "v1/users/me/owns/todos/1", body: Todo.Input(title: "Clean Up 2")) { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Todo.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Clean Up 2")
            }
        }.test(.GET, "v1/users/me/owns/todos/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Todo.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Clean Up 2")
            }

        }
    }
}


final class AuthParentChildUpdateResourceDeprecatedAPITests: BaseVaporRestKitDeprecatedAPITest {
    func testUpdateWithValidData() throws {
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
        }.test(.POST, "v1/users/me/owns/todos", body: Todo.Input(title: "Clean Up")) { res in
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

        }.test(.PUT, "v1/users/me/owns/todos/1", body: Todo.Input(title: "Clean Up 2")) { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Todo.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Clean Up 2")
            }
        }.test(.GET, "v1/users/me/owns/todos/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Todo.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Clean Up 2")
            }

        }
    }
}
