//
//  SendMessageBtn.swift
//  TinderClone
//
//  Created by 洪森達 on 2018/12/15.
//  Copyright © 2018 Sen-da. All rights reserved.
//

import UIKit

class SendMessageBtn: UIButton {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let gradentLayer = CAGradientLayer()
        let leftColor = #colorLiteral(red: 0.979287684, green: 0.1465908587, blue: 0.4451678991, alpha: 1)
        let rightColor = #colorLiteral(red: 0.9901451468, green: 0.4005126357, blue: 0.3075449467, alpha: 1)
        gradentLayer.colors = [leftColor.cgColor,rightColor.cgColor]
        gradentLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradentLayer.endPoint = CGPoint(x: 1, y: 0.5)
       
        layer.cornerRadius = rect.height / 2
        clipsToBounds = true
        layer.insertSublayer(gradentLayer, at: 0)
         gradentLayer.frame = rect
        
    }

}
