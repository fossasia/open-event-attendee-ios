//
//  MainTabBarViewController.swift
//  FOSSAsia
//
//  Created by Apple on 06/07/18.
//  Copyright © 2018 FossAsia. All rights reserved.
//

import UIKit

class MainTabBarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //performSegue(withIdentifier: "ProfileVC", sender: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        performSegue(withIdentifier: "AuthVC", sender: nil)
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
