//
//  User.swift
//  TinderClone
//
//  Created by 洪森達 on 2018/11/23.
//  Copyright © 2018 Sen-da. All rights reserved.
//

import UIKit


struct User:producesCardViewModel {
    
    var fullname:String?
    var age: Int?
    var profession:String?
    var imageUrl1:String?
    var imageUrl2:String?
    var imageUrl3:String?
    var uid:String?
    var minSeekingAge:Int?
    var maxSeekingAge:Int?
    init(_ dictionary:[String:Any]){
        
        self.fullname = dictionary["fullName"] as? String ?? ""
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.imageUrl1 = dictionary["imageUrl1"] as? String
        self.imageUrl2 = dictionary["imageUrl2"] as? String
        self.imageUrl3 = dictionary["imageUrl3"] as? String
        self.minSeekingAge = dictionary["minSeekingAge"] as? Int
        self.maxSeekingAge = dictionary["maxSeekingAge"] as? Int
        
        self.uid = dictionary["uid"] as? String ?? ""
        
    }
    
    
    
    func toCardViewModel() ->CardViewModel{
        
        let attribute = NSMutableAttributedString(string: fullname ?? "", attributes: [NSAttributedString.Key.font :UIFont.systemFont(ofSize: 24, weight: .heavy)])
        let ageString = age != nil ? "\(age!)" : "N\\A"
        attribute.append(NSAttributedString(string: " \(ageString)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .regular)]))
        let professionString = profession != nil ? profession! : "Not Available"
        attribute.append(NSAttributedString(string: " \n\(professionString)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .regular)]))
        var images = [String]()
        if let img1 = imageUrl1 {images.append(img1)}
         if let img2 = imageUrl2 {images.append(img2)}
         if let img3 = imageUrl3 {images.append(img3)}
        return CardViewModel(uid: self.uid ?? "",arttributedString: attribute, aligmment: .left, imageNames: images)

    }
}

