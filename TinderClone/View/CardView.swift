//
//  cardView.swift
//  TinderClone
//
//  Created by 洪森達 on 2018/11/22.
//  Copyright © 2018 Sen-da. All rights reserved.
//

import UIKit
import SDWebImage


protocol CardViewDelegate {
    func didTapMoreInfo(cardViewModel:CardViewModel)
    func didRemoveCardView(cardView:CardView)
}

class CardView: UIView {

    
    var delegate: CardViewDelegate?
    var nextCardView:CardView?
    
    var cardViewModel:CardViewModel!{
        
        didSet{
            
            swipeController.cardViewModel = cardViewModel
            
//            let image = cardViewModel.imageUrls.first ?? ""
//            guard let url = URL(string: image) else {return}
//            imageView.sd_setImage(with: url)
            infomationLabel.attributedText = cardViewModel.arttributedString
            infomationLabel.textAlignment = cardViewModel.aligmment
//            //
//            if cardViewModel.imageUrls.count <= 1 {
//                barStackView.isHidden = true
//            }else{
//                (0..<cardViewModel.imageUrls.count).forEach { (_) in
//                    let barView = UIView()
//                    barView.backgroundColor = defaultColor
//                    barStackView.addArrangedSubview(barView)
//                    barStackView.arrangedSubviews.first?.backgroundColor = .white
//                }
//
//            }
            setupGesture()
//
//           imgIndxObserver()

        }
    }
    
    let swipeController = SwipingPhotosController(isCardViewMode: true)
    
    fileprivate func imgIndxObserver(){
    
        cardViewModel.imgIndexObserve = { [weak self] (idx,ImageUrl) in
//            
//            if let url = URL(string: ImageUrl ?? "") {
//            
////                self?.imageView.sd_setImage(with: url)
//                
//            }
        
            self?.barStackView.arrangedSubviews.forEach({ (v) in
                v.backgroundColor = self?.defaultColor
            })
            self?.barStackView.arrangedSubviews[idx].backgroundColor = .white
        }
        
    }

    deinit {
        print("this card been reclaimed....")
    }
    
    
    fileprivate let detailBtn:UIButton = {
        let bt = UIButton(type: .system)
            bt.setImage(#imageLiteral(resourceName: "info_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        bt.addTarget(self, action: #selector(handleGotoDetailView), for: .touchUpInside)
        return bt
    }()
    
    
    @objc fileprivate func handleGotoDetailView(){
        delegate?.didTapMoreInfo(cardViewModel: cardViewModel)
    }
    
    
    fileprivate let defaultColor = UIColor(white: 0, alpha: 0.1)
//    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "kelly2"))
    fileprivate let gradient = CAGradientLayer()
    fileprivate let infomationLabel:UILabel = {
        let lb = UILabel()
            lb.numberOfLines = 0
            lb.textColor = .white
            return lb
      }()
    fileprivate let barStackView = UIStackView()
    
    
    fileprivate let threshold:CGFloat = 100
  
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        setupView()
     
    }
    
    
    fileprivate func setupGradientLayer(){
        
        gradient.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]
        gradient.locations = [0.5,1.1]
        layer.addSublayer(gradient)
        
    }
    
    override func layoutSubviews() {
        gradient.frame = self.frame
    }
    
    
    fileprivate func setupView(){
//        addSubview(imageView)
//        imageView.layer.cornerRadius = 10
//        imageView.clipsToBounds = true
//        imageView.fillSuperview()
//        imageView.contentMode = .scaleAspectFill
//        setupImageBar()
        let swpieView = swipeController.view!
        addSubview(swpieView)
        swpieView.fillSuperview()
        setupGradientLayer()
        addSubview(infomationLabel)
        infomationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        addSubview(detailBtn)
        detailBtn.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 16, right: 16), size: CGSize(width: 44, height: 44))
    }
    
    fileprivate func setupImageBar(){
        
        addSubview(barStackView)
        barStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: CGSize(width: 0, height: 4))
        barStackView.spacing = 4
        barStackView.distribution = .fillEqually
    }
    
    fileprivate func setupGesture(){
        
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
    
    }
    
    @objc fileprivate func handleTap(_ gesture:UITapGestureRecognizer){
        let location = gesture.location(in: nil)
        let shouldAdvance = location.x > self.frame.width / 2 ? true:false
        
        if shouldAdvance{
            //Next
           cardViewModel.goToNextImg()
            
        }else{
            //Previeous
           cardViewModel.goTOPreviousImg()
        }
    }
    
    @objc fileprivate func handlePan(_ gesture:UIPanGestureRecognizer){
        
        switch gesture.state {
        
        case .began:
            superview?.subviews.forEach({ (subview) in
                subview.layer.removeAllAnimations()
            })
      
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture)
            
        default:
            
            ()
        }

    }
    fileprivate func handleChanged(_ gesture:UIPanGestureRecognizer){
        
        let translation = gesture.translation(in: nil)
        let degrees = translation.x / 20
        let angle = degrees * .pi / 180
        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
        
    }
     fileprivate func handleEnded(_ gesture:UIPanGestureRecognizer){
        
        let translationDirection:CGFloat = gesture.translation(in: nil).x > 0 ? 1:-1
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshold
        
        guard let homeController = self.delegate as? HomeControoler else {return}
        
        if shouldDismissCard{
            
            if translationDirection == 1 {
                homeController.handleLinked()
            }else{
                homeController.handleDislike()
            }
        }else{
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
             
                self.transform = .identity
            })
            
        }
        
        
        
        
//        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//
//            if shouldDismissCard {
//
//                self.frame = CGRect(x: 600 * translationDirection, y: 0, width: self.frame.width, height: self.frame.height)
//            }else{
//
//                self.transform = .identity
//            }
//
//        }) { (_) in
//
//            self.transform = .identity
//            if shouldDismissCard{
//                self.removeFromSuperview()
//                self.delegate?.didRemoveCardView(cardView: self)
//            }
//        }
        
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

}
