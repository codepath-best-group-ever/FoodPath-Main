//
//  StreamViewController.swift
//  FoodPath--Camera
//
//  Created by Kim Chheu on 11/20/21.
//

import UIKit
import Parse

class StreamViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource{
    
    var picture: UIImage!
    var ingredidents = [PFObject]()
    
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className: "chooseIngredients")
        query.findObjectsInBackground(block: { (ingredidents, error) in
            if ingredidents != nil{
                self.ingredidents = ingredidents!
                self.tableView.reloadData()
            }
            
        })
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredidents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsCell") as! IngredientsCell
        
        let ingredient = ingredidents[indexPath.row]
        cell.ingredientNameLabel.text = ingredient["ingredientName"] as! String
        
        return cell
        
    }
    
    

   //**HERE IS THE CODE FOR CHANGING THE BOOLEAN VALUE**
    @IBAction func didCheckIngredient(_ sender: Any) {
        let indexPath = tableView.indexPathForSelectedRow

        let cell = tableView.cellForRow(at: indexPath!) as! IngredientsCell

        let ingredientCheck = PFObject(className: "checkIngredients")
 

        if ((sender as AnyObject).isOn == true) {
            ingredientCheck["isChecked"] = true
            ingredientCheck["ingredientId"] = 1
            ingredientCheck["ingredientName"] = cell.ingredientNameLabel.text


            ingredientCheck.saveInBackground { (success, error) in
                if success{
                    self.dismiss(animated: true, completion: nil)
                    print("Saved!")
                }
                else{
                    print("Error: \(String(describing: error?.localizedDescription))")
                }
            }
        }

    }


    
    
    @IBAction func didPressButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = true
        self.present(picker, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        picture = info[.editedImage] as? UIImage
        
        performSegue(withIdentifier: "goToImageRecognition", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToImageRecognition" {
            let nextDestination = segue.destination as! ImageRecognitionViewController
            nextDestination.cameraPicture = picture
        }
    
    }
    
}



