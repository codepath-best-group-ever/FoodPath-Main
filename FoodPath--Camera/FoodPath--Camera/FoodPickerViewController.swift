//
//  FoodPickerViewController.swift
//  FoodPath--Camera
//
//  Created by Kim Chheu on 11/28/21.
//

import UIKit
import Parse

class FoodPickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    
    var possibleFoods = [PFObject]()
    var foodSuggestions = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        callSearchAPI()
       }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className: "getFoodFromAPI")
        query.findObjectsInBackground(block: { (foods, error) in
            if foods != nil{
                self.possibleFoods = foods!
                self.tableView.reloadData()
            }
            
        })
    }
    
    
func callSearchAPI(){
    let checkedIngredients = PFQuery(className: "checkIngredients")

    var userChecked: [String] = []
    var searchTerm: String = " "
    
    // Retrieve checked ingredients from database
    checkedIngredients.findObjectsInBackground{ (objects, error) -> Void in
        if error == nil{
            if let returnedObjects = objects{
                for object in returnedObjects{
                    if (object["isChecked"] as! NSNumber).boolValue{
                        userChecked.append(object["ingredientName"] as! String)
                    }
                }
            }
            
            for (index, checkedItem) in userChecked.enumerated(){
                searchTerm.append(checkedItem)
                if index < userChecked.count-1{
                    searchTerm.append("+")
                }
            }
            
            
            
            //Set up URL Query to call search API
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "serpapi.com"
            urlComponents.path = "/search"
            urlComponents.queryItems = [
                URLQueryItem(name: "q", value: searchTerm),
                URLQueryItem(name: "api_key", value: "4c43411d817856122333fbeba420b7141241fdd65894d3144add0c4e1467bcdd")
            ]
            guard let someString = urlComponents.url?.absoluteString else { return  }
        
        
            let url = URL(string: someString)!
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
            let task = session.dataTask(with: request) { (data, response, error) in
                 if let error = error {
                        print(error.localizedDescription)
                 } else if let data = data {
                        let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        
                     self.foodSuggestions = dataDictionary["recipes_results"] as! [[String:Any]]
                     let returnedFoods = self.foodSuggestions
                     
                     
                     
        
                      // Add each result to database
                     for (index,foodItem) in returnedFoods.enumerated(){
                         let foodFromAPI = PFObject(className: "getFoodFromAPI")
                         let possibleRecipe = foodItem["title"] as! String
                       
                         foodFromAPI["foodName"] = possibleRecipe
                         foodFromAPI["foodId"] = index + 1
                         foodFromAPI.saveInBackground { (success, error) in
                             if success{
                                 print("Saved!")
                             }
                             else{
                                 print("Error: \(String(describing: error?.localizedDescription))")
                             }
                         }

                     }
                     
                     
                 }
            }
            task.resume()
         
        }
        else{
            print("Error: Empty object")
        }
        
    }
    DispatchQueue.main.async {
                    self.tableView.reloadData()
                }


}
    
   
    
    


func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return possibleFoods.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeOptionCell") as! RecipeOptionCell
    
    let ingredient = possibleFoods[indexPath.row]
    cell.recipeChoiceLabel.text = ingredient["foodName"] as! String
    
    return cell
    
    }

    
    
}
