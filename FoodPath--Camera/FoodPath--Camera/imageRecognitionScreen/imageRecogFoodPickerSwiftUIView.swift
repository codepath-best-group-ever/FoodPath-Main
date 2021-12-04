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
struct imageRecogFoodPickerSwiftUIView: View {
    @ObservedObject var model: FoodModel
    var foodList: [String] = []
    @State var selectedFood: String? = nil

    var body: some View {
        VStack{
            List(model.foodList, id: \.self){ food in
                SelectionCell(Food: food, selectedFood: self.$selectedFood)
            }
            //Text("\(selectedFood)")
        }
    }
}

struct SelectionCell: View {
    let Food: String
    @Binding var selectedFood: String?

    // to implement custom edit button
    @State var isEditing = false
    @State var toConfirm = 0

//    let foodChoices = [
//        "choco cake",
//        "chicken",
//        "breakfast sandwich"
//    ]
    var body: some View {
        HStack {
            Text(Food)
            Spacer()
            if Food == selectedFood {
                Image(systemName: "checkmark")
                    .foregroundColor(.accentColor)
            }
        } .onTapGesture {
            self.selectedFood = self.Food
            print("\(selectedFood)")
        }
    }
}


