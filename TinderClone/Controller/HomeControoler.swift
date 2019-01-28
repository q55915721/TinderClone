//
//  ViewController.swift
//  TinderClone
//
//  Created by 洪森達 on 2018/11/22.
//  Copyright © 2018 Sen-da. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class HomeControoler: UIViewController,SettingControllerTableViewControllerDelegate ,LoginControllerDelegate,CardViewDelegate{
   
    

    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomControls = HomeButtonStackView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       setupLayout()
//       setupdummyCards()
//       fetchUserFromFireStore()
       fetchCurrentUser()
       setupTarget()
       notificationObserver()
        
    }
    
    fileprivate func notificationObserver(){
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "didRegistered"), object: nil, queue: .main) { (_) in
            self.fetchCurrentUser()
        }
        
        
    }
    
    fileprivate func setupTarget(){
        
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        topStackView.settingButton.addTarget(self, action: #selector(handleToSetting), for: .touchUpInside)
        bottomControls.likeButton.addTarget(self, action: #selector(handleLinked), for: .touchUpInside)
        bottomControls.dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
    }
    
    @objc fileprivate func handleToSetting(){
        
        if Auth.auth().currentUser != nil {
            
            let settingController = SettingControllerTableViewController()
                settingController.delegate = self
            let nv = UINavigationController(rootViewController: settingController)
            self.present(nv, animated: true)
        }else{
            
            let registerController = RegisterViewController()
            
            present(registerController, animated: true)
            
        }
    }
    
    func didSaveUserSetting() {
        fetchCurrentUser()
    }
    
    
    @objc fileprivate func handleRefresh(){
        
        fetchCurrentUser()
    }

    
    var cardViewModels = [CardViewModel]()
//    var cardViewModels:[CardViewModel] = {
//
//        let producers = [
//            Advertiser(title: "Slide Out Menu", brandName: "Let's Build That App", posterPhotoName: "slide_out_menu_poster"),
//            User(name: "Kelly", age: 23, profession: "Music DJ", imageNames: ["kelly1","kelly2","kelly3"]),
//            User(name: "Jane", age: 18, profession: "Teacher", imageNames: ["jane1","jane2","jane3"])
//        ] as [producesCardViewModel]
//
//        let viewModel = producers.map({return $0.toCardViewModel()})
//        return viewModel
//    }()
    
    
    var lastFetchedUser:User?
    var user:User?
    let Hub = JGProgressHUD(style: .dark)
    fileprivate func fetchCurrentUser(){
        
        Hub.textLabel.text = "Loading"
        Hub.show(in: self.view)
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        cardsDeckView.subviews.forEach({$0.removeFromSuperview()})
        
        Firestore.firestore().collection("Users").document(uid).getDocument { (snapShot, err) in
            if let err = err {
                print("faild to fetch user",err)
                self.Hub.dismiss()
                return
            }
            
            guard let dic = snapShot?.data() else {return}
            let user = User(dic)
            self.user = user
            self.fetchSwipes()
        }
    }
    
    var spwipes = [String:Int]()
    
    fileprivate func fetchSwipes(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("Swipes").document(uid).getDocument { (snapsoht, err) in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            
            if let data = snapsoht?.data() as? [String: Int] {
                self.spwipes = data
                self.fetchUserFromFireStore()
            }else{
                let data = [uid:0]
                Firestore.firestore().collection("Swipes").document(uid).setData(data, completion: { (error) in
                    if let err = error {
                        print(err.localizedDescription)
                        return
                    }
                    self.spwipes = data
                    self.fetchUserFromFireStore()
                })
                
            }
           
         
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if Auth.auth().currentUser == nil {
            
            let logginVc = LoginController()
                logginVc.delegate = self
            
            let nv = UINavigationController(rootViewController: logginVc)
            self.present(nv, animated: true)
        }
    }
    
    
    func didFinishLoggingIn() {
        fetchCurrentUser()
    }
    
    fileprivate func fetchUserFromFireStore(){
        
        topCarView = nil
      
        if let minValueOfAge = user?.minSeekingAge, let maxValueOfAge = user?.maxSeekingAge {

            let query =  Firestore.firestore().collection("Users").whereField("age", isGreaterThanOrEqualTo: minValueOfAge).whereField("age", isLessThanOrEqualTo: maxValueOfAge)
            query.getDocuments { (snapshot, error) in
                self.Hub.dismiss()
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                var previousCardView:CardView?
                snapshot?.documents.forEach({ (documentSnap) in
                    let userDictionary = documentSnap.data()
                    let user = User(userDictionary)
                    let isNotSelf = user.uid != Auth.auth().currentUser?.uid
//                    let hasNotSwipedBefore = self.spwipes[user.uid!] == nil
                     let hasNotSwipedBefore = true
                    if isNotSelf && hasNotSwipedBefore  {
                        let cardView = self.setupCardFromUser(user: user)
                        previousCardView?.nextCardView = cardView
                        previousCardView = cardView
                        
                        if self.topCarView == nil {
                            self.topCarView = cardView
                        }
                    }
                })
                
            }
        }else {
              self.Hub.dismiss()
            let setting = SettingControllerTableViewController()
            let nv = UINavigationController(rootViewController: setting)
            present(nv, animated: true, completion: nil)
            
        }
        

        
    }
    
    var topCarView:CardView?
    
    @objc  func handleLinked(){
        
        saveToFireStore(didlike: 1)
        performSwipe(translation: 700, angle: 15)
    }
    
    @objc  func handleDislike(){
        saveToFireStore(didlike: 0)
        performSwipe(translation: -700, angle: -15)
    }
    
    fileprivate func saveToFireStore(didlike:Int){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let cardId = topCarView?.cardViewModel.uid else {return}
        
        let data = [cardId:didlike]
        Firestore.firestore().collection("Swipes").document(uid).getDocument { (snapshot, error) in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            
            if snapshot?.exists == true{
                
                Firestore.firestore().collection("Swipes").document(uid).updateData(data, completion: { (error) in
                    if let err = error {
                        print(err.localizedDescription)
                        return
                    }
                    
                    print("sussessfully update...")
                    if didlike == 1 {
                       self.checkIfMatched(cardId: cardId)
                    }
                   
                })
            }else{
                Firestore.firestore().collection("Swipes").document(uid).setData(data, completion: { (error) in
                    if let err = error {
                        print(err.localizedDescription)
                        return
                    }
                    
                    print("sussessfully setData...")
                    if didlike == 1 {
                        self.checkIfMatched(cardId: cardId)
                    }
                })
                
            }
            
            
        }
    }
    
    fileprivate func checkIfMatched(cardId:String){
        
        Firestore.firestore().collection("Swipes").document(cardId).getDocument { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        
            guard let data =  snapshot?.data() else {return}
            guard let uid = Auth.auth().currentUser?.uid else {return}
            let isHasMatched = data[uid] as? Int == 1
            
            if isHasMatched {
                print("Matched....")
                self.showMatchView(cardUserId:cardId)
            }
            
        }
        
        
    }
    
    fileprivate func showMatchView(cardUserId:String){
        
        let matchView = MatchView()
            matchView.currentUser = self.user
            matchView.cardUserId = cardUserId
        view.addSubview(matchView)
        matchView.fillSuperview()
    }
    
    
    
    fileprivate func performSwipe(translation:CGFloat,angle:CGFloat){
        
        let duration = 0.5
        let translationX = CABasicAnimation(keyPath: "position.x")
        translationX.toValue = translation
        translationX.duration = duration
        translationX.fillMode = .forwards
        translationX.isRemovedOnCompletion = false
        translationX.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotationAnimation.toValue = angle * CGFloat.pi / 180
            rotationAnimation.duration = duration
        
        let cardView = topCarView
            topCarView = cardView?.nextCardView
        
        CATransaction.setCompletionBlock {
            cardView?.removeFromSuperview()
        }
        
        cardView?.layer.add(translationX, forKey: "translation")
        cardView?.layer.add(rotationAnimation, forKey: "rotation")
        
        CATransaction.commit()
        
    }
    
    
    func didRemoveCardView(cardView: CardView) {
       
        topCarView?.removeFromSuperview()
        topCarView = topCarView?.nextCardView
    }
    
    
    fileprivate func setupCardFromUser(user:User) -> CardView{
        
            let cardView = CardView(frame: .zero)
                cardView.delegate = self
            cardView.cardViewModel = user.toCardViewModel()
            cardsDeckView.addSubview(cardView)
            cardsDeckView.sendSubviewToBack(cardView)
            cardView.fillSuperview()
    
            return cardView
    }
    
    func didTapMoreInfo(cardViewModel:CardViewModel) {
        
        let userD = UserDetailViewController()
            userD.cardViewModel = cardViewModel
        present(userD, animated: true)
    }
    
    fileprivate func setupdummyCards(){
        
        cardViewModels.forEach { (cardViewModel) in
            let cardView = CardView(frame: .zero)
                cardView.cardViewModel = cardViewModel
            
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
        
    }
    
    
    fileprivate func setupLayout(){
        view.backgroundColor = .white
        
        let overallStackView = UIStackView(arrangedSubviews: [topStackView,cardsDeckView,bottomControls])
            overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overallStackView.bringSubviewToFront(cardsDeckView)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
    }


}

