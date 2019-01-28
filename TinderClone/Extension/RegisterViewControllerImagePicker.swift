//
//  RegisterViewControllerImagePicker.swift
//  TinderClone
//
//  Created by 洪森達 on 2018/11/30.
//  Copyright © 2018 Sen-da. All rights reserved.
//

import UIKit


extension RegisterViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let originalImage = info[.originalImage] as? UIImage {
            registerationViewModel.bindableImage.value = originalImage
        }
        self.dismiss(animated: true)
        
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancel")
        
        self.dismiss(animated: true)
    }
    
    
}
