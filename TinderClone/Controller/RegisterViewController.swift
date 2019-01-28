//
//  RegisterViewController.swift
//  TinderClone
//
//  Created by 洪森達 on 2018/11/28.
//  Copyright © 2018 Sen-da. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class RegisterViewController: UIViewController {
    
    // UI Components
     let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 275).isActive = true
        button.layer.cornerRadius = 27
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleSelectImg), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    let fullNameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 44)
        tf.placeholder = "Enter full name"
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChanges), for: .editingChanged)
        return tf
    }()
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 44)
        tf.placeholder = "Enter email"
        tf.keyboardType = .emailAddress
        tf.addTarget(self, action: #selector(handleTextChanges), for: .editingChanged)
        tf.backgroundColor = .white
        return tf
    }()
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 44)
        tf.placeholder = "Enter password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChanges), for: .editingChanged)
        return tf
    }()

    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
//        button.backgroundColor = #colorLiteral(red: 0.8235294118, green: 0, blue: 0.3254901961, alpha: 1)
        button.backgroundColor = .lightGray
        button.setTitleColor(.gray, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    let gotoLogginBtn:UIButton = {
        let bt = UIButton()
            bt.setTitle("Go To Login", for: .normal)
            bt.setTitleColor(.white, for: .normal)
            bt.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        bt.addTarget(self, action: #selector(handleLoggin), for: .touchUpInside)
        return bt
    }()
    
   @objc fileprivate func handleLoggin(){
    
        self.navigationController?.popViewController(animated: true)
        
    }
    
    let registerHub = JGProgressHUD(style: .light)
    
    @objc fileprivate func handleRegister(){
        self.handleEndEditing()
        
        registerationViewModel.performRegistration { [weak self] (error) in
            if let err = error {
                self?.showProgressInError(err: err)
                return
            }
            
            print("Regiseter in successfully")
            self?.postNotification()
        }
        
    }
    
    
    fileprivate func postNotification(){
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didRegistered"), object: nil)
        }
      
    }
    
    
    fileprivate func showProgressInError(err:Error){
            registerHub.dismiss()
        let hub = JGProgressHUD(style: .light)
            hub.textLabel.text = "Something is wrong!!"
            hub.detailTextLabel.text = err.localizedDescription
            hub.show(in: self.view)
            hub.dismiss(afterDelay: 3)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientLayer()
        view.backgroundColor = .red
        navigationController?.isNavigationBarHidden = true
        setupStackView()
        setupNotificationObserve()
        setupGesture()
        setupRegisterationViewModelObserver()
    }
    
    let registerationViewModel = RegisterationViewModel()
    fileprivate func setupRegisterationViewModelObserver(){
        
        registerationViewModel.isFormVilidObserver.bind { [unowned self] (isformvalid) in
            
            guard let isformValid = isformvalid else {return}
            print("Form is changing, is it valid?", isformValid)
            self.registerButton.isEnabled = isformValid
            if isformValid{
                self.registerButton.backgroundColor = #colorLiteral(red: 0.8288193345, green: 0.09338123351, blue: 0.3257863522, alpha: 1)
                self.registerButton.setTitleColor(.white, for: .normal)
            }else{
                self.registerButton.backgroundColor = .lightGray
                self.registerButton.setTitleColor(.gray, for: .normal)
            }
        }
        
        registerationViewModel.bindableImage.bind { [unowned self](img) in
            
            guard let img = img else {return}
            
            self.selectPhotoButton.setImage(img.withRenderingMode(.alwaysOriginal), for: .normal)
            
        }
        
        registerationViewModel.bindableIsRegister.bind { [unowned self] (isRegister) in
            
            guard let isR = isRegister else {return}
            if isR{
                
                self.registerHub.show(in: self.view)
                self.registerHub.textLabel.text = "REGISTER..."
                
            }else{
                self.registerHub.dismiss()
            }
        }
    
    }
    
    @objc fileprivate func handleSelectImg(){
            let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true)
     
    }
    
    
    @objc fileprivate func handleTextChanges(textField:UITextField){
        if textField == fullNameTextField {
            registerationViewModel.fullName = textField.text
        }else if textField == emailTextField{
             registerationViewModel.email = textField.text
        }else {
             registerationViewModel.passwords = textField.text
        }
    }
    
    deinit {
        print("this view is been reclaimed.....")
    }
    
    
    fileprivate func setupGesture(){
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleEndEditing)))
    }
    
    @objc func handleEndEditing(){
        view.endEditing(true)
        
    }
    
    fileprivate func setupNotificationObserve(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardWillhide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func handleKeyBoardWillShow(notification:Notification){
        
        if let info = notification.userInfo {
            
            guard let value = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            let keyboardHeight = value.cgRectValue.height
            let bottomSpacing = view.frame.height - overallStackView.frame.origin.y - overallStackView.frame.height
            let diffirent = keyboardHeight - bottomSpacing
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: -diffirent - 8)
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func handleKeyBoardWillhide(notification:Notification){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
         self.view.transform = .identity
        })
    }
    
    lazy var verticalStackView:UIStackView = {
        
        let sv = UIStackView(arrangedSubviews: [
            fullNameTextField,
            emailTextField,
            passwordTextField,
            registerButton
        ])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    
    lazy var overallStackView = UIStackView(arrangedSubviews: [
        selectPhotoButton,
        verticalStackView
        ])
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.verticalSizeClass == .compact {
            print("compact")
            overallStackView.axis = .horizontal
        }else if traitCollection.verticalSizeClass == .regular{
            print("regular")
            overallStackView.axis = .vertical
        }else if traitCollection.verticalSizeClass == .unspecified{
              overallStackView.axis = .vertical
            print("unspecified")
        }
    }
    
    fileprivate func setupStackView(){
        view.addSubview(overallStackView)
        overallStackView.axis = .vertical
        selectPhotoButton.widthAnchor.constraint(equalToConstant: 275).isActive = true
       
        overallStackView.spacing = 8
        overallStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        overallStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(gotoLogginBtn)
        gotoLogginBtn.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    let gradientLayer = CAGradientLayer()
    
    override func viewWillLayoutSubviews() {
     
        gradientLayer.frame = view.bounds
    }

    fileprivate func setupGradientLayer(){
        
      
            let topColor = #colorLiteral(red: 0.9862886071, green: 0.3750994802, blue: 0.3780086637, alpha: 1)
            let bottomColor = #colorLiteral(red: 0.892090857, green: 0.1048654541, blue: 0.4604073763, alpha: 1)
        gradientLayer.colors = [topColor.cgColor,bottomColor.cgColor]
        gradientLayer.locations = [0,1]
        view.layer.addSublayer(gradientLayer)
       
        
    }

}
