//
//  GetReceipeViewController.swift
//  FoodPath--Camera
//
//  Created by Menuka Ghalan on 12/3/21.
//

import UIKit
import Parse

private let reuseIdentifier = "Cell"

class GetReceipeViewController: UICollectionViewController,UITableViewDelegate, UITableViewDataSource {
    
    var possibleFoods = [PFObject]()
    var foodSuggestions = [[String:Any]]()
    let myRefreshControl = UIRefreshControl()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    
    
    
    // Set up URL Query and call search API
    func callSearchAPI(){
        let checkedIngredients = PFQuery(className: "chooseIngredients")
        var userChecked: [String] = []
        var searchTerm: String = "Recipes+for+"
        var linkforWebsite: String = "Receipes+for+searchTerm"

        // Retrieve checked ingredients from database
        checkedIngredients.findObjectsInBackground{ (objects, error) -> Void in
            if error == nil{
                if let returnedObjects = objects{
                    for object in returnedObjects{
                        if (object["isChecked"] as! NSNumber).boolValue{
                            userChecked.append(object["ingredientName"] as! String)
                            userChecked.append(object["WebsiteTitle"] as! String)
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
                    URLQueryItem(name: "api_key", value: "8904e8f40f3070f69b5e5b20139add92b3d79e684d3b78a36b129d29a1f934eb")
                    URLQueryItem(name: "api_key", value: "8904e8f40f3070f69b5e5b20139add92b3d79e684d3b78a36b129d29a1f934eb")
                    
                    
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
                         
                         
                         if(self.foodSuggestions != nil){
                             // Add each result to database
                             for (index,websiteTitle) in returnedFoods.enumerated(){
                                 let RecipeFromAPI = PFObject(className: "getRecipesFromAPI")
                                 let possibleRecipe = foodItem["title"] as! String
                                 let linkRecipe = receipeItem["link"] as! String
                                 RecipeFromAPI["websiteURL"] = linkRecipe
                                 RecipeFromAPI["websiteTitle"] = possibleRecipe
                                 RecipeFromAPI["receipeId"] = index + 1
                                 RecipeFromAPI.saveInBackground { (success, error) in
                                     if success{
                                         print("Recipe Saved!")
                                         self.statusLabel.text = "Link of suggested Recipes:"
                                         self.viewDidAppear(true)
                                     }
                                     
                                     else{
                                         print("Error: \(String(describing: error?.localizedDescription))")
                                     }
                                 }

                                }
                             
                         }
                         else{
                             print("No recipes found")
                         }
                    }
              
                }
                task.resume()
             
            }
            else{
                print("Error: Empty object")

            }
            
        }
    }

    
    
    // Back button pushed, go back to stream
    @IBAction func goBack(_ sender: Any) {
        clearData()
        performSegue(withIdentifier: "fromGetReceipeToStream" , sender: nil)
    }
    
    
    
    // View was closed, delete table data
    override func viewDidDisappear(_ animated: Bool) {
        clearData()
    }
    
  
   
                }
            }

}
