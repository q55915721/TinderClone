//
//  SettingControllerTableViewController.swift
//  TinderClone
//
//  Created by 洪森達 on 2018/12/2.
//  Copyright © 2018 Sen-da. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

protocol SettingControllerTableViewControllerDelegate {
    func didSaveUserSetting()
}

class SettingControllerTableViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    var delegate: SettingControllerTableViewControllerDelegate?

    lazy var image1Button = generateBtn(selector: #selector(handleSelectPhoto))
    lazy var image2Button = generateBtn(selector: #selector(handleSelectPhoto))
    lazy var image3Button = generateBtn(selector: #selector(handleSelectPhoto))
    
    @objc fileprivate func handleSelectPhoto(button:UIButton){
        
        let picker = CustomImagePickerController()
            picker.delegate = self
            picker.imageButton = button
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let original = info[.originalImage] as? UIImage else {return}
        let imageBtn = (picker as? CustomImagePickerController)?.imageButton
            imageBtn?.setImage(original.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
        
        let fileName = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "images\(fileName)")
        let hub = JGProgressHUD(style: .dark)
            hub.textLabel.text = "Saving img..."
            hub.show(in: self.view)
        guard let img = original.jpegData(compressionQuality: 0.75) else {return}
        ref.putData(img, metadata: nil) { (_, err) in
            if let err = err {
                print("Failed to save img into fireStorage....",err)
                hub.dismiss()
                return
            }
            
            ref.downloadURL(completion: { (url, error) in
               hub.dismiss()
                
                if let err = error {
                    print("Failed to save img into fireStorage....",err)
                    return
                }
                
                
                guard let url = url?.absoluteString else {return}
                
                if imageBtn == self.image1Button {
                    self.user?.imageUrl1 = url
                }else if imageBtn == self.image2Button {
                    self.user?.imageUrl2 = url
                }else{
                    self.user?.imageUrl3 = url
                }
                
            })
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancel...")
        dismiss(animated: true)
    }
    
    
    
    
    func generateBtn(selector:Selector)->UIButton{
       
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        return button
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNaView()
        tableView.tableFooterView = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.keyboardDismissMode = .interactive
        fetchUserFromFireStore()
    }
    
    var user:User?
    
    fileprivate func fetchUserFromFireStore(){
        
        guard let uid = Auth.auth().currentUser?.uid else{return}
        Firestore.firestore().collection("Users").document(uid).getDocument { (snapShot, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            guard let data = snapShot?.data() else {return}
            self.user = User(data)
            self.loadUserImagesFromFireStore()
            self.tableView.reloadData()
            
        }
    }
    
    fileprivate func loadUserImagesFromFireStore(){
        
        if let imgUrl = user?.imageUrl1 , let url = URL(string: imgUrl){
            SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (img, _, _, _, _, _) in
                guard let img = img else {return}
                self.image1Button.setImage(img.withRenderingMode(.alwaysOriginal), for: .normal)
            }
            
        }
        
        if let imgUr2 = user?.imageUrl2 , let url = URL(string: imgUr2){
            SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (img, _, _, _, _, _) in
                guard let img = img else {return}
                self.image2Button.setImage(img.withRenderingMode(.alwaysOriginal), for: .normal)
            }
            
        }
        
        if let imgUr3 = user?.imageUrl3 , let url = URL(string: imgUr3){
            SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (img, _, _, _, _, _) in
                guard let img = img else {return}
                self.image3Button.setImage(img.withRenderingMode(.alwaysOriginal), for: .normal)
            }
            
        }
    

    }
    
    
    //MARK: -TableView

    lazy var header:UIView = {
        let header = UIView()
        header.addSubview(image1Button)
        let padding:CGFloat = 16
        image1Button.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: padding, right: 0))
        image1Button.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [image2Button,image3Button])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        header.addSubview(stackView)
        stackView.anchor(top: header.topAnchor, leading: image1Button.trailingAnchor, bottom: header.bottomAnchor, trailing: header.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        
        return header
    }()
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 300
        }else{
            return 40
        }
     
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
   
        if section == 0 {
            return header
        }
        
        let headerLabel = HeaderLabel()
        
        switch section {
        case 1:
            headerLabel.text = "Name"
        case 2:
            headerLabel.text = "Profession"
        case 3:
            headerLabel.text = "Age"
        case 4:
               headerLabel.text = "Bio"
        default:
            headerLabel.text = "Seeking Age Range"
        }
        
        headerLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return headerLabel
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0:1
    }
    
    
   @objc fileprivate func handleMinSlider(){
        evaluateMinMax()
    
    }
    
    
    @objc fileprivate func handleMaxSlider(){
        
        evaluateMinMax()
        
    }
    
    
    fileprivate func evaluateMinMax(){
        
        guard let cell = tableView.cellForRow(at: [5,0]) as? SeekingAgwRangeCell else {return}
        
        let minValue = Int(cell.minSlider.value)
        var maxValue = Int(cell.maxSlider.value)
        
        maxValue = max(minValue, maxValue)
        
        cell.minLabel.text = "Min \(minValue)"
        cell.maxLabel.text = "Max \(maxValue)"
           
        user?.minSeekingAge = minValue
        user?.maxSeekingAge = maxValue
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 5 {
            let seekingCell = SeekingAgwRangeCell(style: .default, reuseIdentifier: nil)
            seekingCell.minSlider.addTarget(self, action: #selector(handleMinSlider), for: .valueChanged)
            seekingCell.maxSlider.addTarget(self, action: #selector(handleMaxSlider), for: .valueChanged)
            seekingCell.minLabel.text = "Min \(user?.minSeekingAge ?? 18)"
            seekingCell.maxLabel.text = "Max \(user?.maxSeekingAge ?? 88)"
            seekingCell.minSlider.value = Float(user?.minSeekingAge ?? 18)
            seekingCell.maxSlider.value = Float(user?.maxSeekingAge ?? 88)
            return seekingCell
        }
        
        let cell = SettingsCell(style: .default, reuseIdentifier: nil)
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter Your Name"
            cell.textField.text = user?.fullname
            cell.textField.addTarget(self, action: #selector(handleChangedName), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Enter Your Profession"
            cell.textField.text = user?.profession
            cell.textField.addTarget(self, action: #selector(handleChangedProfession), for: .editingChanged)
        case 3:
            cell.textField.placeholder = "Enter Your Age"
            cell.textField.keyboardType = .numberPad
            cell.textField.addTarget(self, action: #selector(handleChangedAge), for: .editingChanged)
            if let age = user?.age {
                cell.textField.text = String(age)
            }
        default:
            cell.textField.placeholder = "Enter Bio"
        }
        
        return cell
    }
    
    
    @objc func handleChangedName(textField:UITextField){
        
        user?.fullname = textField.text ?? ""
    }
    @objc func handleChangedProfession(textField:UITextField){
        user?.profession = textField.text ?? ""
        
    }
    @objc func handleChangedAge(textField:UITextField){
        user?.age = Int(textField.text ?? "")
    }

    fileprivate func setupNaView() {
       
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let logoutBtn = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(handleLogout))
        logoutBtn.tintColor = .red

        let saveBtn = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSetting))
        
        navigationItem.rightBarButtonItems = [
            logoutBtn,
            saveBtn
        ]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleDismissal))
    }
    
    
    @objc fileprivate func handleSetting(){
        
        print("saving....")
        if let age = user?.age , let profession = user?.profession {
            
            let hub = JGProgressHUD(style: .dark)
            hub.textLabel.text = "Saving..."
            hub.show(in: self.view)
            guard let uid = Auth.auth().currentUser?.uid else {return}
            
            
            var data:[String:Any] = [
                "uid": uid,
                "fullName":user?.fullname ?? "",
                "imageUrl1":user?.imageUrl1 ?? "",
                "age":age,
                "profession":profession,
                "minSeekingAge":user?.minSeekingAge ?? 18,
                "maxSeekingAge":user?.maxSeekingAge ?? 88
            ]
            
            if let imageUrl2 = user?.imageUrl2 , let imageUrl3 = user?.imageUrl3 {
                data["imageUrl2"] = imageUrl2
                data["imageUrl3"] = imageUrl3
            }
            
            
            
            Firestore.firestore().collection("Users").document(uid).setData(data) { (error) in
                hub.dismiss()
                if let err = error {
                    print("Failed to save settings...",err.localizedDescription)
                    return
                }
                
                self.dismiss(animated: true, completion: {
                    
                    self.delegate?.didSaveUserSetting()
                    
                })
                
            }
            
            
        }else {
            self.showErr()
        }

    }
    
    fileprivate func showErr(){
        let hub = JGProgressHUD(style: .dark)
        hub.textLabel.text = "Age and Profession is required..."
        hub.show(in: self.view)
        hub.dismiss(afterDelay: 3)
    
    }
    
    @objc fileprivate func handleLogout(){
        
        try? Auth.auth().signOut()
        dismiss(animated: true)
    }
    
    @objc fileprivate func handleDismissal(){

        if let age = user?.age , let pro = user?.profession {
            self.dismiss(animated: true)
            print(age,pro)
        }else {
            self.showErr()
        }
      
    }


}
