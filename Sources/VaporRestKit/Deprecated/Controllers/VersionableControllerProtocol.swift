//
//  
//  
//
//  Created by Sergey Kazakov on 26.04.2020.
//

import Vapor

@available(*, deprecated, message: "Use ResourceController, RelatedResourceController and RelationsController API instead")
public protocol VersionableController {
    associatedtype ApiVersion

    func setupAPIMethods(on routeBuilder: RoutesBuilder, for endpoint: String, with version: ApiVersion)
}
