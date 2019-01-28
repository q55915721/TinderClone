//
//  MatchView.swift
//  TinderClone
//
//  Created by 洪森達 on 2018/12/15.
//  Copyright © 2018 Sen-da. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
class MatchView: UIView {
    
    
    var currentUser:User!{
        didSet{
            
        }
    }
    

    
    var cardUserId:String!{
        
        didSet{
            
            fetchCardUser()
            
            
        }
    }
    
    
    
    fileprivate let isAMatchImageView:UIImageView = {
        
            let iv = UIImageView(image: #imageLiteral(resourceName: "itsamatch"))
                iv.contentMode = .scaleAspectFill
            return iv
    }()
    
    fileprivate let descripetionLabel:UILabel = {
        
        let lb = UILabel()
            lb.text = "You and X have liked \neach other"
            lb.numberOfLines = 0
            lb.textAlignment = .center
            lb.font = UIFont.systemFont(ofSize: 20)
            lb.textColor = .white
        
        return lb
    }()
    
    fileprivate let currentUserImageView:UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "kelly1"))
            iv.clipsToBounds = true
            iv.contentMode = .scaleAspectFill
            iv.layer.borderWidth = 2
            iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    fileprivate let cardUserImageView:UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "lady4c"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    
    fileprivate let sendMessageBtn:UIButton = {
        
        let bt = SendMessageBtn(type: .system)
            bt.setTitle("Send Messages!", for: .normal)
            bt.setTitleColor(.white, for: .normal)
        return bt
    }()
    
    
    fileprivate let keepSwipingBtn:UIButton = {
        
        let bt = KeepSwipingBtn(type: .system)
        bt.setTitle("Keep Swiping!", for: .normal)
         bt.setTitleColor(.white, for: .normal)
        return bt
    }()
    
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
   
        setupVisualEffectView()
        
        setupLayout()
        
   
    }
    
    fileprivate func setupAnimation(){
        views.forEach({$0.alpha = 1})
        let angle = 30 * CGFloat.pi / 180

        currentUserImageView.transform = CGAffineTransform(rotationAngle: angle)
            .concatenating(CGAffineTransform(translationX: 200, y: 0))
        cardUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
            .concatenating(CGAffineTransform(translationX: -200, y: 0))
        
//        currentUserImageView.transform = CGAffineTransform(translationX: 200, y: 0)
//        cardUserImageView.transform = CGAffineTransform(translationX: -200, y: 0)
        
        sendMessageBtn.transform = CGAffineTransform(translationX: 500, y: 0)
        keepSwipingBtn.transform = CGAffineTransform(translationX: -500, y: 0)
        
        
//        UIView.animate(withDuration: 5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//            self.currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
//            self.cardUserImageView.transform = CGAffineTransform(rotationAngle: angle)
//        }) { (_) in
//
//        }
        
        UIView.animateKeyframes(withDuration: 1.2, delay: 0, options: .calculationModeCubic, animations: {

            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.45, animations: {

                self.currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
                self.cardUserImageView.transform = CGAffineTransform(rotationAngle: angle)
            })

            UIView.addKeyframe(withRelativeStartTime: 0.55, relativeDuration: 0.55, animations: {
                self.currentUserImageView.transform = .identity
                self.cardUserImageView.transform = .identity
            })


        }) { (_) in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {

                self.sendMessageBtn.transform = .identity
                self.keepSwipingBtn.transform = .identity

            })
        }
    }
    
    
    lazy var views = [
     isAMatchImageView,
     descripetionLabel,
     currentUserImageView,
     cardUserImageView,
     sendMessageBtn,
     keepSwipingBtn
    ]
    
    fileprivate func setupLayout(){
        views.forEach { (v) in
            addSubview(v)
            v.alpha = 0
        }
        
        let width:CGFloat = 140
        
        isAMatchImageView.anchor(top: nil, leading: nil, bottom: descripetionLabel.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 16, right: 0), size: .init(width: 300, height: 80))
        isAMatchImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        descripetionLabel.anchor(top: nil, leading: leadingAnchor, bottom: currentUserImageView.topAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 32, right: 0), size: .init(width: 0, height: 50))
        
        currentUserImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: centerXAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16), size: .init(width: width, height: width))
        currentUserImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        currentUserImageView.layer.cornerRadius = width / 2
        
        
        cardUserImageView.anchor(top: nil, leading: centerXAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0), size: .init(width: width, height: width))
        cardUserImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        cardUserImageView.layer.cornerRadius = width / 2
        
        sendMessageBtn.anchor(top: currentUserImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 32, left: 48, bottom: 0, right: 48), size: .init(width: 0, height: 60))
        keepSwipingBtn.anchor(top: sendMessageBtn.bottomAnchor, leading: sendMessageBtn.leadingAnchor, bottom: nil, trailing: sendMessageBtn.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 60))
        
        
    }
    
    
    let visualView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    fileprivate func setupVisualEffectView(){
        
        addSubview(visualView)
        visualView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissal)))
        visualView.fillSuperview()
        visualView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.visualView.alpha = 1
        }) { (_) in
            
        }
        
    }
    
    
    fileprivate func fetchCardUser() {
        Firestore.firestore().collection("Users").document(cardUserId).getDocument { (sanpshot, err) in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            
            guard let data = sanpshot?.data() else {return}
            let user = User(data)
            guard let currentUserUrl = URL(string: self.currentUser.imageUrl1 ?? "" ) else {return}
            guard let url = URL(string: user.imageUrl1 ?? "") else {return}
            
            
            self.cardUserImageView.sd_setImage(with: url, completed: { (_, _, _, _) in
                self.currentUserImageView.sd_setImage(with: currentUserUrl)
                self.descripetionLabel.text = "You and \(user.fullname ?? "") have liked \neach other"
                self.setupAnimation()
            })
        }
    }
    
    
    @objc fileprivate func handleDismissal(){
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
