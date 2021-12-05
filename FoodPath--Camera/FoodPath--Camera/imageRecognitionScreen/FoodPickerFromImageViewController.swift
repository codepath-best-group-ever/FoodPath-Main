//
//  FoodPickerFromImageViewController.swift
//  FoodPath--Camera
//
//  Created by Eugene Tye on 12/2/21.
//

import UIKit
import SwiftUI

class FoodPickerFromImageViewController: UIViewController {
    var foodList: [String] = []
    private var model = FoodModel(foodList:[])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.model.foodList = ["choco", "banana", "breakfast sandwich"]
        self.model.foodList = foodList
        // adding a swift UI view
        addSwiftUIView()
    }
    
    // back button
    @IBSegueAction func swiftUIAction(_ coder: NSCoder) -> UIViewController?{
        let controller = UIHostingController(coder: coder, rootView: imageRecogFoodPickerSwiftUIView(model:model){ [weak self] in
            self?.dismiss(animated: true)
        })
//        let host = UIHostingController(rootView: imageRecogFoodPickerSwiftUIView(model: model) { [weak self] in
//            self?.navigationController?.popViewController(animated: true)
//        })
//        self.navigationController?.navigationBar.isHidden = true
//        self.navigationController?.pushViewController(host, animated: true)
        return controller
    }

    
    func addSwiftUIView() {
        let swiftUIView = imageRecogFoodPickerSwiftUIView(model: model)
        let controller = UIHostingController(rootView: swiftUIView)
    
        // add as a child of the current view controller
        addChild(controller)
        
        // add the swiftui view to the view controller view hierarchy
        view.addSubview(controller.view)
        
        // Notify the hosting controller that it has been moved to the current view controller.
        controller.didMove(toParent: self)
        
        // setup the constraints to update the swiftui view boundaries
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            controller.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            controller.view.heightAnchor.constraint(equalTo: view.heightAnchor),
            controller.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            controller.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
