//
//  TopNavigationStackView.swift
//  TinderClone
//
//  Created by 洪森達 on 2018/11/22.
//  Copyright © 2018 Sen-da. All rights reserved.
//

import UIKit

class TopNavigationStackView: UIStackView {

    let settingButton = UIButton(type: .system)
    let messageButton = UIButton(type: .system)
    let fireImage = UIImageView(image: #imageLiteral(resourceName: "app_icon"))
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        settingButton.setImage(#imageLiteral(resourceName: "top_left_profile").withRenderingMode(.alwaysOriginal), for: .normal)
        messageButton.setImage(#imageLiteral(resourceName: "top_right_messages").withRenderingMode(.alwaysOriginal), for: .normal)
        fireImage.contentMode = .scaleAspectFit
        
        heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        [settingButton,UIView(),fireImage,UIView(),messageButton].forEach { (v) in
            
            addArrangedSubview(v)
        }
        
        distribution = .equalCentering
        
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
}
