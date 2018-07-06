//
//  MainTabBarViewController.swift
//  FOSSAsia
//
//  Created by Apple on 06/07/18.
//  Copyright © 2018 FossAsia. All rights reserved.
//

import UIKit

class MainTabBarViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
         performSegue(withIdentifier: "Profile", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Profile"{
            var vc = segue.destination as! ProfileViewController
            //Data has to be a variable name in your RandomViewController
        }
    }

    
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
