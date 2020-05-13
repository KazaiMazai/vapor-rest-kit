import XCTest
@testable import VaporRestKit

final class VaporRestKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(VaporRestKit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
