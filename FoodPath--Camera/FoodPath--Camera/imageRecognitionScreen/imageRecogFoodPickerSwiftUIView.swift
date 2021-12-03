//
//  imageRecogFoodPickerSwiftUIView.swift
//  FoodPath--Camera
//
//  Created by Elaine Chan on 12/2/21.
//
import UIKit
import SwiftUI

// import data from parent vc
class FoodModel: ObservableObject{
    @Published var foodList: [String]
    init(foodList: [String]){
        self.foodList = foodList
    }
}



struct imageRecogFoodPickerSwiftUIView:
    View {
    var foodList: [String] = []
    @ObservedObject var model: FoodModel
    @State private var selection: String?

//    let foodChoices = [
//        "choco cake",
//        "chicken",
//        "breakfast sandwich"
//    ]
    var body: some View {
        NavigationView{
            List(model.foodList, id: \.self, selection: $selection){ food in
                Text(food)
            }
            .navigationTitle("Recognized Food Dishes")
            .toolbar{
                EditButton()
            }
        }
    }
}

//struct imageRecogFoodPickerSwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        imageRecogFoodPickerSwiftUIView()
//    }
//}

//struct imageRecogFoodPickerSwiftUIView: UIViewRepresentable {
//    typealias UIVIewType =
//}
