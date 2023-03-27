//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 26.03.2023.
//

@testable import VaporRestKit
import XCTVapor

class BackwardPaginationWithTwoItemsPerPageTests: BackwardPaginationWithOneItemPerPageTests {
    override var perPage: Int { 2 }
}

class BackwardPaginationWithOneItemPerPageTests: BaseVaporRestKitTest {
    var perPage: Int { 1 }
    var pages: [[Star.Output]] = []
    var lastPageCursor: String = ""

    override func setUpWithError() throws {
        try super.setUpWithError()
        try seed()
        try routes()

        lastPageCursor = try getPrevCursorForTheLastPage()
        pages = try getAllPages()
    }

    func testCursorPagination() throws {
        var prevCursor = lastPageCursor
        for page in pages {
            try app.test(.GET, "v1/stars?before=\(prevCursor)&limit=\(perPage)") { res in
                XCTAssertEqual(res.status, .ok)

                XCTAssertContent(CursorPage<Star.Output>.self, res) { content in
                    prevCursor = content.metadata.prevCursor ?? prevCursor

                    XCTAssertEqual(page, content.items)
                }
            }
        }
    }
}

extension BackwardPaginationWithOneItemPerPageTests {
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

        for endIndex in stride(from: stars.count - 1, through: 0, by: -perPage) {
            let startIndex = max(0, endIndex - perPage)
            pages.append(Array(stars[startIndex..<endIndex]))
        }

        return pages
    }

    func getPrevCursorForTheLastPage() throws -> String {
        var nextCursor: String = ""
        var prevCursor: String = ""

        try app.test(.GET, "v1/stars?limit=\(perPage)") { res in

            XCTAssertContent(CursorPage<Star.Output>.self, res) {
                nextCursor = $0.metadata.nextCursor ?? ""

            }
        }

        var hasMore = true
        while hasMore {
            try app.test(.GET, "v1/stars?after=\(nextCursor)&limit=\(perPage)") { res in

                XCTAssertContent(CursorPage<Star.Output>.self, res) {
                    nextCursor = $0.metadata.nextCursor ?? nextCursor
                    prevCursor = $0.metadata.prevCursor ?? prevCursor

                    hasMore =  $0.metadata.nextCursor != nil
                }
            }
        }

        return prevCursor
    }
}
