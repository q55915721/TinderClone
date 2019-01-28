//
//  UserDetailViewController.swift
//  TinderClone
//
//  Created by 洪森達 on 2018/12/6.
//  Copyright © 2018 Sen-da. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController ,UIScrollViewDelegate{

    var cardViewModel:CardViewModel!{
        
        didSet{
           
            
            infoLabel.attributedText = cardViewModel.arttributedString
            swipingPhotosController.cardViewModel = cardViewModel
        }
    }
    
    
    lazy var scrollView:UIScrollView = {
        let sv = UIScrollView()
            sv.alwaysBounceVertical = true
            sv.contentInsetAdjustmentBehavior = .never
            sv.delegate = self
        
        return sv
    }()
    
    
    let swipingPhotosController = SwipingPhotosController()
    
    let infoLabel:UILabel = {
        let lb = UILabel()
            lb.text =  "User name 30\nDoctor\nSome bio text down below"
            lb.numberOfLines = 0
        return lb
    }()
    
    let dismissBtn:UIButton = {
        let bt = UIButton(type: .system)
            bt.setImage(#imageLiteral(resourceName: "dis").withRenderingMode(.alwaysOriginal), for: .normal)
            bt.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return bt
    }()
    
    
    lazy var dislikeBtn = self.generateBtn(image: #imageLiteral(resourceName: "dismiss_circle"), selector: #selector(handleDislike))
    lazy var superlikeBtn = self.generateBtn(image: #imageLiteral(resourceName: "super_like_circle"), selector: #selector(handleDislike))
    lazy var likeBtn = self.generateBtn(image: #imageLiteral(resourceName: "like_circle"), selector: #selector(handleDislike))
    
    
    @objc fileprivate func handleDislike(){
        
        
    }
    
    fileprivate func generateBtn(image:UIImage,selector:Selector) -> UIButton {
        let bt = UIButton(type: .system)
            bt.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
            bt.addTarget(self, action: selector, for: .touchUpInside)
            bt.imageView?.contentMode = .scaleAspectFill
        
        return bt
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupBlurEffectView()
        setupBtnControl()
    }
    
    fileprivate func setupBtnControl(){
        
        let stackView = UIStackView(arrangedSubviews: [dislikeBtn,superlikeBtn,likeBtn])
            stackView.spacing = -12
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 300, height: 80))
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    fileprivate func setupBlurEffectView(){
        let blurEffect = UIBlurEffect(style: .regular)
        let visual = UIVisualEffectView(effect: blurEffect)
        view.addSubview(visual)
        visual.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    fileprivate func setupLayout(){
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        let swipingPhotos = swipingPhotosController.view!
        
        scrollView.addSubview(swipingPhotos)
    
        scrollView.addSubview(infoLabel)
        infoLabel.anchor(top: swipingPhotos.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        scrollView.addSubview(dismissBtn)
        dismissBtn.anchor(top: swipingPhotos.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: -25, left: 0, bottom: 0, right: 16), size: CGSize(width: 50, height: 50))
        
        
    }
    @objc fileprivate func handleDismissal(){
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate let extraHeight:CGFloat = 80
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let swipingPhotos = swipingPhotosController.view!
        
        swipingPhotos.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width + extraHeight)
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let changeY = -scrollView.contentOffset.y
        print(changeY)
        
        var width = view.frame.width + changeY * 2
        width = max(view.frame.width, width)
       let swipingPhotos = swipingPhotosController.view!
        swipingPhotos.frame = CGRect(x: min(0, -changeY), y: min(0, -changeY), width: width, height: width + extraHeight)
        
      
    }

}
