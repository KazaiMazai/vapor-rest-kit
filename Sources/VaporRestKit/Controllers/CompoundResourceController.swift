//
//  
//  
//
//  Created by Sergey Kazakov on 04.05.2020.
//

import Vapor
import Fluent

struct CompoundResourceController {
    let underlyingControllers: [APIMethodsProviding]

    init(with undelryingControllers: [APIMethodsProviding]) {
        self.underlyingControllers = undelryingControllers
    }
}

//MARK:- APIMethodsProviding

extension CompoundResourceController: APIMethodsProviding {
    func addMethodsTo(_ routeBuilder: RoutesBuilder, on endpoint: String) {
        underlyingControllers.forEach { $0.addMethodsTo(routeBuilder, on: endpoint) }
    }
}
