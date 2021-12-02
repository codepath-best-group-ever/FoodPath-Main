//
//  SwiftyGIFViewController.swift
//  FoodPath--Camera
//
//  Created by Eugene Tye on 12/2/21.
//

import UIKit
import SwiftyGif

extension LogoAnimationViewController: SwiftyGifDelegate {

    func gifDidStop(sender: UIImageView){
        //print("Gif did stop.")
        performSegue(withIdentifier: "showStream", sender: nil)
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
