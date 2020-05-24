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
        for i in 0..<CurrentUser.shared.user!.recipes.count {
            if recipeId == CurrentUser.shared.user!.recipes[i].id{
                    self.favoriteCollectionView.deleteItems(at: [IndexPath(row: i, section: 0)])
            }
        }
        self.favoriteCollectionView.reloadData()
        
    }
}

//MARK: Class
class ProfileController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate, UINavigationControllerDelegate , UIImagePickerControllerDelegate{
    //MARK: Outlets
    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    //MARK: Properties
    
    //MARK: LiveCycle View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkAndLoadProfileImage()

        favoriteCollectionView.delegate = self
        favoriteCollectionView.dataSource = self
        
        userNameLabel.text = "\(CurrentUser.shared.user!.firstName!) \(CurrentUser.shared.user!.lastName!)"
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let instructionsVC = segue.destination as? InstructionsController{
            guard let recipe = sender as? Recipe else {return}
            instructionsVC.recipe = recipe
        }
    }
    
    //MARK: Actions
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
        return CurrentUser.shared.user!.recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let favoriteCell = favoriteCollectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCell", for: indexPath) as! FavoriteViewCell
        let recipe = CurrentUser.shared.user!.recipes[indexPath.row]
        
        favoriteCell.favoriteRecipeName.text = recipe.name
        favoriteCell.favoriteRecipeLevel.text =  recipe.level.description
        favoriteCell.favoriteRecipeTime.text = recipe.time
        favoriteCell.favoriteImageView.sd_setImage(with: recipe.image)
        favoriteCell.favoriteImageView.layer.cornerRadius = 10
        favoriteCell.recipe = recipe
        favoriteCell.vc = self
        favoriteCell.delegate = self
        favoriteCell.layer.borderWidth = 2
        favoriteCell.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        return favoriteCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell: \(indexPath.row) tapped")
        self.performSegue(withIdentifier: "profileToInstructions", sender: CurrentUser.shared.user!.recipes[indexPath.row])
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
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {return}
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



