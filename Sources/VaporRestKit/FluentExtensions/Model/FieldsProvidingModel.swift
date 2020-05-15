//
//  
//  
//
//  Created by Sergey Kazakov on 06.04.2020.
//

import Fluent

//MARK:- FieldsProvidingModel
        
public protocol FieldsProvidingModel: Model {
    associatedtype Fields: FieldKeyRepresentable
}
