//
//  Advertiser.swift
//  TinderClone
//
//  Created by 洪森達 on 2018/11/23.
//  Copyright © 2018 Sen-da. All rights reserved.
//

import UIKit


struct Advertiser:producesCardViewModel {
    
    let title:String
    let brandName:String
    let posterPhotoName:String
    
    
    func toCardViewModel() ->CardViewModel{
        
        let attribute = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font :UIFont.systemFont(ofSize: 36, weight: .heavy)])
        attribute.append(NSAttributedString(string: "\n" + brandName, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 24, weight: .bold)]))
       
        return CardViewModel(uid: "" ,arttributedString: attribute, aligmment: .center, imageNames: [posterPhotoName])
        
    }
}


