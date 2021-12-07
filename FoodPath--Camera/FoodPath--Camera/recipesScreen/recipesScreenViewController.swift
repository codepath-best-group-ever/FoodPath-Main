//
//  recipesScreenViewController.swift
//  FoodPath--Camera
//
//  Created by Elaine Chan on 12/5/21.
//

import UIKit

class recipesScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    // to determine which screen the data was passed from
    var screenName: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    var food: String = ""
    var foodSuggestions = [[String:Any]]()
    var recipeSuggestion: [String] = []
    //var selectedRecipe = IndexPath = []
    
    // back button
    
    @IBAction func unwindSegueBackButton(_ sender: Any) {
        if screenName == "image"{
            performSegue(withIdentifier: "backToFoodPickerFromImageRecog", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchAPI()
        
        // to fix
        self.tableView.reloadData()

        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func searchAPI(){
        var searchTerm: String = "Recipes+for+"
        
        // add food dish to search term
        searchTerm.append(food)
        
        // set up URL Query to call search API
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "serpapi.com"
        urlComponents.path = "/search"
        urlComponents.queryItems = [
                            URLQueryItem(name: "q", value: searchTerm),
                            URLQueryItem(name: "api_key", value: "8904e8f40f3070f69b5e5b20139add92b3d79e684d3b78a36b129d29a1f934eb")
                        ]
                        guard let someString = urlComponents.url?.absoluteString else { return  }
        let url = URL(string: someString)!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 0)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
    
                 self.foodSuggestions = dataDictionary["recipes_results"] as! [[String:Any]]
                 //print("\(self.foodSuggestions)")
                 let returnedFoods = self.foodSuggestions
                 if(dataDictionary["recipes_results"] != nil){
                     // Add each result to database
                     for (_,foodItem) in returnedFoods.enumerated(){
                         let recipe = foodItem["link"] as! String
                         print("\(recipe)")
                         self.recipeSuggestion.append(recipe)
                         // to do: append both link and source; table view will only display source
                     }
                 }
             }
        }
        task.resume()
    }
    
    // TO FIX: use async functionality.
    // table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeSuggestion.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipesTableViewCell", for: indexPath) as! recipesTableViewCell
        print("\(recipeSuggestion[indexPath.row])")
        cell.Label.text = recipeSuggestion[indexPath.row]

        return cell
    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // Unselect the row.
//        tableView.deselectRow(at: indexPath, animated: false)
//
//        selectedRecipe = indexPath
//
//        // make checkmark appear
//        let cell = tableView.cellForRow(at: indexPath)
//        cell?.accessoryType = .checkmark
//        for row in 0..<tableView.numberOfRows(inSection: indexPath.section) {
//            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: indexPath.section)) {
//                cell.accessoryType = row == indexPath.row ? .checkmark : .none
//            }
//        }
//    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
