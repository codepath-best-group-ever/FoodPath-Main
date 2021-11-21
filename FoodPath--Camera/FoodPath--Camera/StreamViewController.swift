//
//  StreamViewController.swift
//  FoodPath--Camera
//
//  Created by Kim Chheu on 11/20/21.
//

import UIKit

class StreamViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var picture: UIImage!
    
    @IBOutlet weak var cameraButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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



