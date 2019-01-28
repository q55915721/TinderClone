//
//  Bindable.swift
//  TinderClone
//
//  Created by 洪森達 on 2018/11/30.
//  Copyright © 2018 Sen-da. All rights reserved.
//

import Foundation


class Bindable<T>{
    
    var value: T? {
        
        didSet{
            
            observer?(value)
        }
    }
    
    var observer:((T?)->())?
    
    
    func bind(observer: @escaping (T?)->() ){
        
        self.observer = observer
    }
    
    
}
