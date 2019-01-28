//
//  SettingsCell.swift
//  TinderClone
//
//  Created by 洪森達 on 2018/12/3.
//  Copyright © 2018 Sen-da. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    

    let textField:settingTextField = {
        
        let tf = settingTextField()
            tf.placeholder = "Enter Name"
        return tf
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(textField)
        textField.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
