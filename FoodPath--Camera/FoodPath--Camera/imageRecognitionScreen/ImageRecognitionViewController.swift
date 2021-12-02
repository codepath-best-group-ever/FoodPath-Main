//
//  ImageRecognitionViewController.swift
//  FoodPath--Camera
//
//  Created by Kim Chheu, Elaine Chan, Menuka Ghalan on 11/20/21.
//

import UIKit
import SwiftUI

class ImageRecognitionViewController: UIViewController, ObservableObject{
    var imageIsNotNull = false
    var foodList = ""
    @IBAction func confirmImage(_ sender: Any) {
        if (imageIsNotNull == true){
            func prepare(for segue: UIStoryboardSegue, sender: Any?) {

                let destinationVC = segue.destination as! FoodPickerFromImageViewController
                destinationVC.foodList = foodList
            }
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var foodDishesLabel: UILabel!
    
    @IBOutlet weak var displayTitle: UILabel!
    @IBOutlet weak var galleryUIButton: UIButton!
    @IBOutlet weak var cameraUIButton: UIButton!
    // a predictor instance that uses Vision and Core ML to generate strings from a photo
    var firstRun = true
    let imagePredictor = ImagePredictor()
    let predictionsToShow = 5
    
}

// handles open camera/gallery function
extension ImageRecognitionViewController {
    @IBAction func openCameraBtn(_ sender: Any) {
        // Show options for the source picker only if the camera is available.
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            present(photoPicker, animated: false)
            return
        }

        present(cameraPicker, animated: false)
    }
    
    @IBAction func openGalleryBtn(_ sender: Any) {
        present(photoPicker, animated: false)
    }
    
    // deprecated code to update UIImageView
//    var cameraPicture: UIImage!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        imageView.image = cameraPicture
//
//    }
}

// update UIImageView with image chosen from gallery/taken from camera
extension ImageRecognitionViewController {
    func updateImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.imageView.image = image
            self.imageIsNotNull = true
        }
    }
    
    func updateFoodDish(_ predictions: String) {
        DispatchQueue.main.async {
            self.foodDishesLabel.text = predictions
        }
        // hide prediction labels if photo hasn't been selected/taken
        if firstRun {
            DispatchQueue.main.async {
                self.firstRun = false
                self.foodDishesLabel.isHidden = false
                self.displayTitle.isHidden = false
            }
        }
    }
    
    func userSelectedPhoto(_ photo: UIImage){
        updateImage(photo)
        updateFoodDish("Doing the wok...")
        DispatchQueue.global(qos: .userInitiated).async {
            self.classifyImage(photo)
        }
    }
}

// make requests to image classifier ML Model
extension ImageRecognitionViewController{
    // MARK: Image prediction methods
    /// Sends a photo to the Image Predictor to get a prediction of its content.
    /// - Parameter image: A photo.
    private func classifyImage(_ image: UIImage) {
        do {
            try self.imagePredictor.makePredictions(for: image,
                                                    completionHandler: imagePredictionHandler)
        } catch {
            print("Vision was unable to make a prediction...\n\n\(error.localizedDescription)")
        }
    }

    /// The method the Image Predictor calls when its image classifier model generates a prediction.
    /// - Parameter predictions: An array of predictions.
    /// - Tag: imagePredictionHandler
    private func imagePredictionHandler(_ predictions: [ImagePredictor.Prediction]?) {
        
        guard let foodList = predictions else {
            updateFoodDish("No predictions. (Check console log.)")
            return
        }

        let formattedPredictions = formatPredictions(foodList)

        let predictionString = formattedPredictions.joined(separator: "\n")
        updateFoodDish(predictionString)
    }

    /// Converts a prediction's observations into human-readable strings.
    /// - Parameter observations: The classification observations from a Vision request.
    /// - Tag: formatPredictions
    private func formatPredictions(_ predictions: [ImagePredictor.Prediction]) -> [String] {
        // Vision sorts the classifications in descending confidence order.
        let topPredictions: [String] = predictions.prefix(predictionsToShow).map { prediction in
            var name = prediction.classification

            // For classifications with more than one name, keep the one before the first comma.
            if let firstComma = name.firstIndex(of: ",") {
                name = String(name.prefix(upTo: firstComma))
            }

            return "\(name) - \(prediction.confidencePercentage)%"
        }

        return topPredictions
    }
}
