//
//  SettingsTextField.swift
//  TinderClone
//
//  Created by 洪森達 on 2018/12/3.
//  Copyright © 2018 Sen-da. All rights reserved.
//

import UIKit

class settingTextField:UITextField {
    
    override var intrinsicContentSize: CGSize{
        
        return .init(width: 0, height: 44)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 16, dy: 0)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 16, dy: 0)
    }
}

