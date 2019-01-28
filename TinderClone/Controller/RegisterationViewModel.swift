//
//  RegisterationViewModel.swift
//  TinderClone
//
//  Created by 洪森達 on 2018/11/29.
//  Copyright © 2018 Sen-da. All rights reserved.
//

import UIKit
import Firebase

class  RegisterationViewModel {
    
    
    var bindableImage = Bindable<UIImage>()
    var bindableIsRegister = Bindable<Bool>()
    var fullName:String?{didSet{isFormVilidity()}}
    var email:String?{didSet{isFormVilidity()}}
    var passwords:String?{didSet{isFormVilidity()}}
    
    
    
    func performRegistration(completion:@escaping (_ error:Error?)->()){
        guard let email = email else {return}
        guard let passwords = passwords else {return}
        
        bindableIsRegister.value = true
        
        Auth.auth().createUser(withEmail: email, password: passwords) { (firUser, error) in
            
            if let err = error {
                completion(err)
                self.bindableIsRegister.value = false
                return
            }
            
              print("Successfully registered user:", firUser?.user.uid ?? "")
            
            self.saveImageToFireStorage(completion: { (erorr) in
                completion(error)
            })
        }

    }
    
    
    fileprivate func saveImageToFireStorage(completion: @escaping (_ error :Error?)->()){
        
        let fileName = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(fileName)")
        guard let image = self.bindableImage.value?.jpegData(compressionQuality: 0.75) else {return}
        ref.putData(image, metadata: nil, completion: { (meta, error) in
            if let err = error {
                completion(err)
                return
            }
            
            ref.downloadURL(completion: { (url, error) in
                if let err = error{
                    completion(err)
                    return
                }
                self.bindableIsRegister.value = false
                print("Download url of our image is:", url?.absoluteString ?? "")
                guard let urlString = url?.absoluteString else {return}
                self.saveIntoFireStore(imgUrl: urlString, completion: completion)
            })
        })
    }
    
    
    fileprivate func saveIntoFireStore(imgUrl:String,completion: @escaping (_ err:Error?)->()){
        
        let uid = Auth.auth().currentUser?.uid ?? ""
        let document = ["fullName":fullName ?? "","uid":uid,"imageUrl1":imgUrl]
        Firestore.firestore().collection("Users").document(uid).setData(document) { (err) in
            if let err = err {
                completion(err)
                return
            }
            
            completion(nil)
        }
    }
    
    
    
    func isFormVilidity(){
        
        let isFormVilidity = fullName?.isEmpty == false && email?.isEmpty == false && passwords?.isEmpty == false
        
           isFormVilidObserver.value = isFormVilidity
    }
    
    var isFormVilidObserver = Bindable<Bool>()
}
