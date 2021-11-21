//
//  ViewController.swift
//  objectIdentifier
//
//  Created by Elaine Chan on 11/20/21.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageViewObject: UIImageView!
    @IBOutlet weak var imageDescriptionTextView: UITextView!

    var imagePicker:UIImagePickerController!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker=UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        // Do any additional setup after loading the view.
    }

    @IBAction func takePicture(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageViewObject.image=info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imagePicker.dismiss(animated: true, completion: nil)
        imageIdentifier(image: (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!)
    }
    
    // image identifier api using coreML and vision
    func imageIdentifier(image:UIImage){
        guard let model = try? VNCoreMLModel(for:Resnet50().model) else {
            fatalError("cannot load ML model")
        }
        let request = VNCoreMLRequest(model:model){
            [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let firstResult = results.first else{
                      fatalError("cannot get result from VNCoreMLRequest")
                  }
            DispatchQueue.main.async {
                self?.imageDescriptionTextView.text = "confidence = " + "\( Int(firstResult.confidence*100))%" + "\n object: " + "\((firstResult.identifier))"
            }
        }
        guard let ciImage = CIImage(image:image) else {
            fatalError("cannot convert to CIImage")
        }
        let imageHandler =  VNImageRequestHandler(ciImage:ciImage)
        DispatchQueue.global(qos: .userInteractive).async {
            do{
                try imageHandler.perform([request])
            }catch{
                print("Error \(error)")
            }
        }
    }
    
}

