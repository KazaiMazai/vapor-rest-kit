//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 09.06.2020.
//

@testable import VaporRestKit
import XCTVapor

final class AuthChildParentPatchResourceTests: BaseVaporRestKitTest {
    func testPatchWithValidData() throws {
        try routes()

        try app.test(.GET, "v1/users/1") { res in
            XCTAssertEqual(res.status, .notFound)
        }.test(.GET, "v1/referral_codes/1") { res in
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
        }.test(.POST, "v1/users/me/referred/referral_codes", body: ReferralCode.Input(code: "HELLO123")) { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(ReferralCode.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.code, "HELLO123")
            }
        }.test(.GET, "v1/referral_codes/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(ReferralCode.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.code, "HELLO123")
            }
        }.test(.GET, "v1/users/me/referred/referral_codes/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(ReferralCode.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.code, "HELLO123")
            }

        }.test(.PATCH, "v1/users/me/referred/referral_codes/1", body: ReferralCode.PatchInput(code: "GOODBYE")) { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(ReferralCode.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.code, "GOODBYE")
            }
        }.test(.GET, "v1/users/me/referred/referral_codes/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(ReferralCode.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.code, "GOODBYE")
            }
        }
    }
}

final class AuthChildParentPatchResourceDeprecatedAPITests: BaseVaporRestKitDeprecatedAPITest {
    func testPatchWithValidData() throws {
        try routes()

        try app.test(.GET, "v1/users/1") { res in
            XCTAssertEqual(res.status, .notFound)
        }.test(.GET, "v1/referral_codes/1") { res in
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
        }.test(.POST, "v1/users/me/referred/referral_codes", body: ReferralCode.Input(code: "HELLO123")) { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(ReferralCode.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.code, "HELLO123")
            }
        }.test(.GET, "v1/referral_codes/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(ReferralCode.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.code, "HELLO123")
            }
        }.test(.GET, "v1/users/me/referred/referral_codes/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(ReferralCode.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.code, "HELLO123")
            }

        }.test(.PATCH, "v1/users/me/referred/referral_codes/1", body: ReferralCode.PatchInput(code: "GOODBYE")) { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(ReferralCode.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.code, "GOODBYE")
            }
        }.test(.GET, "v1/users/me/referred/referral_codes/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(ReferralCode.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.code, "GOODBYE")
            }
        }
    }
}
