//
//  TEMPViewController.swift
//  FoodPath--Camera
//
//  Created by Kim Chheu on 12/6/21.
//

import UIKit

class TEMPViewController: UIViewController {

    @IBOutlet weak var selectedRecipeLabel: UILabel!
    var selectedRecipe: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(selectedRecipe)
        selectedRecipeLabel.text = selectedRecipe
    }
    

}
