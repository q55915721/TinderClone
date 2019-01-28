//
//  CardViewModel.swift
//  TinderClone
//
//  Created by 洪森達 on 2018/11/23.
//  Copyright © 2018 Sen-da. All rights reserved.
//

import UIKit


protocol producesCardViewModel {
    func toCardViewModel() ->CardViewModel
}

class CardViewModel {
    
    
    let arttributedString:NSAttributedString
    let aligmment:NSTextAlignment
    let imageUrls:[String]
    let uid:String
    
    init(uid: String ,arttributedString:NSAttributedString,aligmment:NSTextAlignment,imageNames:[String]){
        self.uid = uid
        self.arttributedString = arttributedString
        self.aligmment = aligmment
        self.imageUrls = imageNames
    }
    
    
    fileprivate var imgIndex = 0 {
        didSet{
            
            let imageName = imageUrls[imgIndex]
            imgIndexObserve?(imgIndex, imageName)
        }
    }
    
    var imgIndexObserve:((Int,String?)->())?
    
    
    func goToNextImg(){
        
        imgIndex = min(imgIndex + 1, imageUrls.count - 1)
    }
    
    func goTOPreviousImg(){
        
        imgIndex = max(0, imgIndex - 1)
    }
    
    
    deinit {
        print("have been reclaiment.....")
    }
    
    
}


