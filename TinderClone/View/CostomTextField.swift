//
//  CostomTextField.swift
//  TinderClone
//
//  Created by 洪森達 on 2018/11/28.
//  Copyright © 2018 Sen-da. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    let height:CGFloat
    let padding:CGFloat

    init(padding:CGFloat,height:CGFloat){
        self.padding = padding
        self.height = height
        super.init(frame: .zero)
        layer.cornerRadius = height / 2
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
         return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override var intrinsicContentSize: CGSize {
        
        return CGSize(width: 0, height: height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
