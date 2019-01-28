//
//  HomeButtonStackView.swift
//  TinderClone
//
//  Created by 洪森達 on 2018/11/22.
//  Copyright © 2018 Sen-da. All rights reserved.
//

import UIKit

class HomeButtonStackView: UIStackView {

    
    
    static func generateBtb(img:UIImage) -> UIButton {
        
        let btn = UIButton(type: .system)
            btn.setImage(img.withRenderingMode(.alwaysOriginal), for: .normal)
            btn.imageView?.contentMode = .scaleAspectFill
        
        return btn
    }
    
    
    let refreshButton = generateBtb(img: #imageLiteral(resourceName: "refresh_circle"))
    let dislikeButton = generateBtb(img: #imageLiteral(resourceName: "dismiss_circle"))
    let superLikeButton = generateBtb(img: #imageLiteral(resourceName: "super_like_circle"))
    let likeButton = generateBtb(img: #imageLiteral(resourceName: "like_circle"))
    let specialButton = generateBtb(img: #imageLiteral(resourceName: "boost_circle"))
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        heightAnchor.constraint(equalToConstant: 90).isActive = true
        distribution = .fillEqually
        
        
        [refreshButton, dislikeButton, superLikeButton, likeButton, specialButton].forEach { (btn) in
            self.addArrangedSubview(btn)
        }
        
//        let subviews = [#imageLiteral(resourceName: "refresh_circle"),#imageLiteral(resourceName: "dismiss_circle"),#imageLiteral(resourceName: "super_like_circle"),#imageLiteral(resourceName: "like_circle"),#imageLiteral(resourceName: "boost_circle")].map { (img) -> UIView in
//            let buttton = UIButton(type: .system)
//                buttton.setImage(img.withRenderingMode(.alwaysOriginal), for: .normal)
//            return buttton
//
//        }
//
//        subviews.forEach { (v) in
//            addArrangedSubview(v)
//        }
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
