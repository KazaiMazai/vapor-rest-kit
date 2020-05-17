//
//  
//  
//
//  Created by Sergey Kazakov on 01.05.2020.
//

import Vapor
import Fluent

protocol ItemResourceControllerProtocol: ResourceControllerProtocol {

}

extension ItemResourceControllerProtocol where Self: ResourceModelProvider {
    var sortingHandler: SortingUnsupported<Model> { return SortingUnsupported<Model>() }
    var filteringHandler: FilteringUnsupported<Model> { return FilteringUnsupported<Model>() }
}
 
