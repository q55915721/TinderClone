//
//  PhotoController.swift
//  TinderClone
//
//  Created by 洪森達 on 2018/12/9.
//  Copyright © 2018 Sen-da. All rights reserved.
//


import UIKit


class PhotoController: UIViewController {
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "app_icon"))
    
    init(imageUrl:String) {
        
        if let url = URL(string: imageUrl) {
            imageView.sd_setImage(with: url)
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.fillSuperview()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

