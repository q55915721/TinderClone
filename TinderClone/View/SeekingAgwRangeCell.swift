//
//  SeekingAgwRangeCell.swift
//  TinderClone
//
//  Created by 洪森達 on 2018/12/5.
//  Copyright © 2018 Sen-da. All rights reserved.
//

import UIKit

class SeekingAgwRangeCell: UITableViewCell {
    
    class CustomLabel:UILabel {
        override var intrinsicContentSize: CGSize{
            return CGSize(width: 80, height: 0)
        }
    }
    
    let minSlider:UISlider = {
        
        let slider = UISlider()
            slider.minimumValue = 18
            slider.maximumValue = 88
            return slider
        
    }()
    
    let maxSlider:UISlider = {
        
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 88
        return slider
    }()
    
    let minLabel:UILabel = {
        
        let lb = CustomLabel()
            lb.text = "Min 88"
        
        return lb
    }()
    
    let maxLabel:UILabel = {
        
        let lb = CustomLabel()
        lb.text = "Max 88"
        
        return lb
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    fileprivate func setupView(){
        
        let overallStackView = UIStackView(arrangedSubviews: [
            
                UIStackView(arrangedSubviews: [minLabel,minSlider]),
                UIStackView(arrangedSubviews: [maxLabel,maxSlider])
            ])
        addSubview(overallStackView)
        overallStackView.axis = .vertical
        overallStackView.spacing = 16
        overallStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
}
