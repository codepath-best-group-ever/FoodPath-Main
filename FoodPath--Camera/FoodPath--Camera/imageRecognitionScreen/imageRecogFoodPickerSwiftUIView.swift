//
//  imageRecogFoodPickerSwiftUIView.swift
//  FoodPath--Camera
//
//  Created by Elaine Chan on 12/2/21.
//
import UIKit
import SwiftUI


struct imageRecogFoodPickerSwiftUIView: View {
    
    @State private var selection: String?
    let foodChoices = [
        "choco cake",
        "chicken",
        "breakfast sandwich"
    ]
    var body: some View {
        NavigationView{
            List(foodChoices, id: \.self, selection: $selection){ food in
                Text(food)
            }
            .navigationTitle("Recognized Food Dishes")
            .toolbar{
                EditButton()
            }
        }
    }
}

struct imageRecogFoodPickerSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        imageRecogFoodPickerSwiftUIView()
    }
}

//struct imageRecogFoodPickerSwiftUIView: UIViewRepresentable {
//    typealias UIVIewType =
//}
