//
//  ProfileController.swift
//  MeatMarket
//
//  Created by YardenSwisa on 09/10/2019.
//  Copyright © 2019 YardenSwisa. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

//MARK: Extension Protocol Remove Favorite
extension ProfileController:RemoveFavoriteProtocol{
    func refresh(recipeId:String){
        for i in 0..<CurrentUser.shared.user!.favoriteRecipes.count {
            if recipeId == CurrentUser.shared.user!.favoriteRecipes[i].id{
                    self.profileCollectionView.deleteItems(at: [IndexPath(row: i, section: 0)])
            }
        }
        self.profileCollectionView.reloadData()
        
    }
}

//MARK: Class
class ProfileController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate, UINavigationControllerDelegate , UIImagePickerControllerDelegate{
    //MARK: Outlets
    @IBOutlet weak var profileCollectionView: UICollectionView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var segmentCV: UISegmentedControl!
    
    
    //MARK: Properties
    var userNameStr:String = ""
    
    //MARK: LiveCycle View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkAndLoadProfileImage()

        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
        
        userNameStr = "\(CurrentUser.shared.user!.firstName!) \(CurrentUser.shared.user!.lastName!)"
        userNameLabel.text = userNameStr
        
    }
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear() ProfileVC")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let instructionsVC = segue.destination as? InstructionsController{
            guard let recipe = sender as? Recipe else {return}
            instructionsVC.recipe = recipe
        }
    }
    
    //MARK: Actions
    @IBAction func segmentTapped(_ sender: UISegmentedControl) {
        profileCollectionView.reloadData()
     }
    
    @IBAction func addImageTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose Source Camera or Library", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
            (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }else{
                HelperFuncs.showToast(message: "Camera not Available", view: self.view)
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)

        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK: CollecionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch segmentCV.selectedSegmentIndex {
        case 0:
            return CurrentUser.shared.user!.favoriteRecipes.count
        case 1:
            return CurrentUser.shared.user!.myRecipes.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let favoriteCell = profileCollectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCell", for: indexPath) as! FavoriteViewCell
        switch segmentCV.selectedSegmentIndex {
        case 0:
            
            let recipe = CurrentUser.shared.user!.favoriteRecipes[indexPath.row]
            favoriteCell.populate(recipe: recipe, vc: self)
            break
        case 1:
            let recipe = CurrentUser.shared.user!.myRecipes[indexPath.row]
            favoriteCell.populate(recipe: recipe, vc: self)
            break
        default:
            break
        }
        
        return favoriteCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell: \(indexPath.row) tapped")
        switch segmentCV.selectedSegmentIndex {
        case 0:
            self.performSegue(withIdentifier: "profileToInstructions", sender: CurrentUser.shared.user!.favoriteRecipes[indexPath.row])
            break
        case 1:
            self.performSegue(withIdentifier: "profileToInstructions", sender: CurrentUser.shared.user!.myRecipes[indexPath.row])
            break
        default:
            break
        }

    }

    //MARK:Picker Profile Image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        
        profileImageView.image = image.circleMasked
        
        uploadProfileImage(image, complition: nil)
        dismiss(animated: true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func uploadProfileImage(_ image: UIImage, complition: ((_ url:String?)->())?){
        let uid = CurrentUser.shared.user?.id
        let storageRef = Storage.storage().reference(forURL: "gs://meat-markett.appspot.com/images/")
        let storage = storageRef.child("profileImage").child(uid!)
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {return}
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        storage.putData(imageData, metadata: metaData) { (storageMetaData, error) in
            if error != nil {
                HelperFuncs.showToast(message: error!.localizedDescription, view: self.view)
                print("putData Error: \(error!.localizedDescription)")
                return
            }
        }
    }
    
    fileprivate func checkAndLoadProfileImage() {
        if CurrentUser.shared.user?.image != nil{
            HelperFuncs.getData(from: (CurrentUser.shared.user?.image)!) { (data, URLResponse, error) in
                guard let data = data, error == nil else {return}
                DispatchQueue.main.async() {
                    let image = UIImage(data: data)
                    self.profileImageView.image = image!.circleMasked
                }
            }
        }
    }
    
}



