//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 09.06.2020.
//


@testable import VaporRestKit
import XCTVapor

final class AuthChildParentCreateDeleteRelationTests: BaseVaporRestKitTest {
    func testCreateWithValidDataAndDelete() throws {
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
        }.test(.POST, "v1/referral_codes", body: ReferralCode.Input(code: "HELLO123")) { res in
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
        }.test(.POST, "v1/users/me/referred/referral_codes/1/relation") { res in
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

        }.test(.DELETE, "v1/users/me/referred/referral_codes/1/relation") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(ReferralCode.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.code, "HELLO123")
            }
        }.test(.GET, "v1/users/me/referred/referral_codes/1") { res in
            XCTAssertEqual(res.status, .notFound)

        }.test(.GET, "v1/referral_codes/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(ReferralCode.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.code, "HELLO123")
            }
        }
    }
}


final class AuthChildParentCreateDeleteRelationDeprecatedAPITests: BaseVaporRestKitDeprecatedAPITest {
    func testCreateWithValidDataAndDelete() throws {
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
        }.test(.POST, "v1/referral_codes", body: ReferralCode.Input(code: "HELLO123")) { res in
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
        }.test(.POST, "v1/users/me/referred/referral_codes/1/relation") { res in
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

        }.test(.DELETE, "v1/users/me/referred/referral_codes/1/relation") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(ReferralCode.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.code, "HELLO123")
            }
        }.test(.GET, "v1/users/me/referred/referral_codes/1") { res in
            XCTAssertEqual(res.status, .notFound)

        }.test(.GET, "v1/referral_codes/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(ReferralCode.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.code, "HELLO123")
            }
        }
    }
}
