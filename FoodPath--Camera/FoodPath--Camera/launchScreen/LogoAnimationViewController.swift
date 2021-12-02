//
//  LogoAnimationViewController.swift
//  FoodPath--Camera
//
//  Created by Elaine Chan on 12/2/21.
//

import UIKit
import SwiftyGif

class LogoAnimationViewController: UIViewController {
    
    @IBOutlet weak var logoAnimationImageView: UIImageView!
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0

        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.logoAnimationImageView.delegate = self
        view.backgroundColor = UIColorFromHex(rgbValue: 0x185227, alpha: 1)
        
        // Load gif
        do{
            let gif = try UIImage(gifName: "launchScreen")
            self.logoAnimationImageView.setGifImage(gif, loopCount: 1)
            
        }catch{
            print(error)
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
 
