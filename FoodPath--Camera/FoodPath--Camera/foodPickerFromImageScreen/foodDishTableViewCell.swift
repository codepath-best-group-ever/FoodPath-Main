//
//  foodDishTableViewCell.swift
//  FoodPath--Camera
//
//  Created by Elaine Chan on 12/5/21.
//

import UIKit

class foodDishTableViewCell: UITableViewCell {
    
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
