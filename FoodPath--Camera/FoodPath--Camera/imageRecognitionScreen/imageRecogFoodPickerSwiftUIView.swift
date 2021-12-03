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

struct GradientBackgroundStyle: ButtonStyle {
 
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [Color("DarkGreen"), Color("LightGreen")]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(40)
            .padding(.horizontal, 20)
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
            .toolbar {
                    ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                        Button("Select Food Dish", action: {
                            print("Button pressed")
                        })
                    }
            }
        }

    }
}

