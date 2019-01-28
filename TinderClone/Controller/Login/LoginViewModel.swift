//
//  LoginModelView.swift
//  TinderClone
//
//  Created by 洪森達 on 2018/12/5.
//  Copyright © 2018 Sen-da. All rights reserved.
//

import UIKit
import Firebase


class LoginViewModel {
    
    
    var isFormValid = Bindable<Bool>()
    var isLoggingIn = Bindable<Bool>()
    
    var email:String? {didSet{ checkoutIsFormValid() }}
    var passwords:String? {didSet{ checkoutIsFormValid() }}
    
    
    
    func checkoutIsFormValid(){
        
        let isValid = email?.isEmpty == false && passwords?.isEmpty == false
        
        isFormValid.value = isValid
        
    }
    
    func performLogin(completion: @escaping (Error?) -> ()) {
        guard let email = email, let password = passwords else { return }
        isLoggingIn.value = true
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            completion(err)
        }
    }
    
    
}
