//
//  AboutUsViewController.swift
//  MyFormulaApp
//
//  Created by Apple on 25/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    @IBOutlet var txtAboutUs: UITextView!
    @IBOutlet var MenuView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MenuView.addBorderShadow(shadowOpacity: 0.5, shadowRadius: 5, shadowColor: UIColor.black)
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnMenu(_ sender: UIButton) {
        
        let slidemenu = self.slideMenuController()
        
        slidemenu?.openLeft()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
