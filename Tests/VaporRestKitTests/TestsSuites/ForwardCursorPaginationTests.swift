//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 26.03.2023.
//

@testable import VaporRestKit
import XCTVapor

class ForwardPaginationWithTwoItemsPerPageTests: ForwardPaginationWithOneItemPerPageTests {
    override var perPage: Int { 2 }
}

class ForwardPaginationWithOneItemPerPageTests: BaseVaporRestKitTest {
    var perPage: Int { 1 }
    var pagesExpectation: [[Star.Output]] = []
    var cursor: String = ""

    override func setUpWithError() throws {
        try super.setUpWithError()
        try seed()
        try routes()
        cursor = try getNextCursorForInitialPage()
        pagesExpectation = try getAllPages()
    }

    func testCursorPagination() throws {
        var nextCursor = cursor
        for page in pagesExpectation.dropFirst() {
            try app.test(.GET, "v1/stars?after=\(nextCursor)&limit=\(perPage)") { res in
                XCTAssertEqual(res.status, .ok)

                XCTAssertContent(CursorPage<Star.Output>.self, res) { content in
                    nextCursor = content.metadata.nextCursor ?? nextCursor

                    XCTAssertEqual(page, content.items)
                }
            }
        }
    }
}

extension ForwardPaginationWithOneItemPerPageTests {
    func getAllElements() throws -> [Star.Output]  {
        try Star.query(on: app.db)
            .sort(\Star.$id, .ascending)
            .all()
            .wait()
            .map { Star.Output($0) }
    }

    func getAllPages() throws -> [[Star.Output]]  {
        let stars = try getAllElements()
        var pages: [[Star.Output]] = []

        for startIndex in stride(from: 0, through: stars.count, by: perPage) {
            let endIndex = min(stars.count, startIndex + perPage)
            pages.append(Array(stars[startIndex..<endIndex]))
        }

        return pages
    }

    func getNextCursorForInitialPage() throws -> String {
        var nextCursor: String = ""

        try app.test(.GET, "v1/stars?limit=\(perPage)") { res in

            XCTAssertContent(CursorPage<Star.Output>.self, res) {
                nextCursor = $0.metadata.nextCursor ?? ""

            }
        }

        return nextCursor
    }
}
