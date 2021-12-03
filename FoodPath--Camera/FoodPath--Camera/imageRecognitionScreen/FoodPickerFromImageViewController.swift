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
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // adding a swift UI view
        
        let swiftUIView = imageRecogFoodPickerSwiftUIView()
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        // add as a child of the current view controller
        addChild(hostingController)

        // add the swiftui view to the view controller view hierarchy
        view.addSubview(hostingController.view)

        // setup the constraints to update the swiftui view boundaries
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            view.bottomAnchor.constraint(equalTo: hostingController.view.bottomAnchor),
            view.rightAnchor.constraint(equalTo: hostingController.view.rightAnchor)
        ]

        NSLayoutConstraint.activate(constraints)

        // Notify the hosting controller that it has been moved to the current view controller.
        hostingController.didMove(toParent: self)
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
