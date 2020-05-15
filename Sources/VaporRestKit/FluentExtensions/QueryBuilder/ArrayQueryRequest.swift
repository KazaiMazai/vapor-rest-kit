//
//  
//  
//
//  Created by Sergey Kazakov on 02.05.2020.
//

import Vapor
import Fluent


//MARK:- SingleCodingKey Protocol

protocol SingleCodingKey: RawRepresentable, CodingKey {
    static var key: Self { get }
}

//MARK:- ArrayQueryRequest

struct ArrayQueryRequest<RequestCodingKey: SingleCodingKey>: Decodable {
    static var separator: Character { "," }

    let values: [String]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RequestCodingKey.self)
        let sortingKeysString = try container.decodeIfPresent(String.self, forKey: RequestCodingKey.key) ?? ""

        self.values = sortingKeysString.split(separator: ArrayQueryRequest.separator).map { String($0) }
    }
}



