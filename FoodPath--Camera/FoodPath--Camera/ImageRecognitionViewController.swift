//
//  ImageRecognitionViewController.swift
//  FoodPath--Camera
//
//  Created by Kim Chheu on 11/20/21.
//

import UIKit

class ImageRecognitionViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var cameraPicture: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = cameraPicture
    
    }


}
