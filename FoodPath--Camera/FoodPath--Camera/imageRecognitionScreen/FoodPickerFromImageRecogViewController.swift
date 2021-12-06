//
//  FoodPickerFromImageRecogViewController.swift
//  FoodPath--Camera
//
//  Created by Eugene Tye on 12/5/21.
//

import UIKit

class FoodPickerFromImageRecogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    // store an array of recommended food dishes
    var foodList: [String] = []
    
    // find which cell is being tapped
    var selectedFood: IndexPath = []
    
    // button to segue to recipes screen
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBAction func goToRecipesVC(_ sender: Any) {
        if selectedFood != []{
            //perform segue when food dish is selected
            performSegue(withIdentifier: "goToRecipes", sender: nil)
        }
    }
    
    // back button
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        // unwind segue
        if identifier == "goBack"{
            foodList.removeAll()
            print("Removing food!")
        }
        // segue to recipes screen
        else if segue.identifier == "goToRecipes" {
            let nextDestination = segue.destination as! recipesScreenViewController
            nextDestination.food = foodList[selectedFood.row]
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // cutom table view cell
        let nib = UINib(nibName: "foodDishTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "foodDishTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // tableview functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodDishTableViewCell", for: indexPath) as! foodDishTableViewCell
        cell.myLabel.text = foodList[indexPath.row]
        cell.myImageView.image = UIImage(named: "check-mark_2714-fe0f")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Unselect the row.
        tableView.deselectRow(at: indexPath, animated: false)
        
        selectedFood = indexPath
        
        // make checkmark appear
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        for row in 0..<tableView.numberOfRows(inSection: indexPath.section) {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: indexPath.section)) {
                cell.accessoryType = row == indexPath.row ? .checkmark : .none
            }
        }
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

extension UIView{
    @discardableResult
        func applyGradient(colours: [UIColor]) -> CAGradientLayer {
            return self.applyGradient(colours: colours, locations: nil)
        }

        @discardableResult
        func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
            let gradient: CAGradientLayer = CAGradientLayer()
            gradient.frame = self.bounds
            gradient.colors = colours.map { $0.cgColor }
            gradient.locations = locations
            self.layer.insertSublayer(gradient, at: 0)
            return gradient
        }
}
