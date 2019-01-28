//
//  HeaderLabel.swift
//  TinderClone
//
//  Created by 洪森達 on 2018/12/3.
//  Copyright © 2018 Sen-da. All rights reserved.
//

import UIKit


class HeaderLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: 16, dy: 0))
    }
}

