//
//  SlideViewController.swift
//  MyFormulaApp
//
//  Created by Apple on 21/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

var fromPage = 0

class SlideViewController: SlideMenuController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func awakeFromNib() {
        
        if(fromPage == 0)
        {
            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "dashBoardViewController") {
                self.mainViewController = controller
            }
        }
        else if(fromPage == 1)
        {
            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "aboutUsViewController") {
                self.mainViewController = controller
            }
            
        }
        
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "menuViewController") {
            self.leftViewController = controller
        }
        super.awakeFromNib()
        
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
