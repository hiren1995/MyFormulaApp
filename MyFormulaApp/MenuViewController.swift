//
//  MenuViewController.swift
//  MyFormulaApp
//
//  Created by Apple on 21/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    

    @IBOutlet var MenuTableView: UITableView!
    
    
    let MenuList = ["Dashboard","About Us","Contact Us","Share Application","Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        MenuTableView.delegate = self
        MenuTableView.dataSource = self
        
        
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return MenuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = MenuTableView.dequeueReusableCell(withIdentifier: "menuTableViewCell", for: indexPath) as! MenuTableViewCell
        
        cell.selectionStyle = .none
        
        cell.lblMenuList.text = MenuList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if(indexPath.row == 2)
        {
            let email = "kartikk55@gmail.com"
            if let url = URL(string: "mailto:\(email)") {
                UIApplication.shared.open(url)
            }
        }
        else if(indexPath.row == 1)
        {
             fromPage = 1
            
             let storyboard = UIStoryboard(name: "Main", bundle: nil)
             let slideViewController = storyboard.instantiateViewController(withIdentifier: "slideViewController") as! SlideViewController
            
             self.present(slideViewController, animated: false, completion: nil)
        }
        
        else if(indexPath.row == 0)
        {
             fromPage = 0
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let slideViewController = storyboard.instantiateViewController(withIdentifier: "slideViewController") as! SlideViewController
            
            self.present(slideViewController, animated: false, completion: nil)
        }
        else if(indexPath.row == 3)
        {
            if let name = NSURL(string: "https://itunes.apple.com/in/app/enova-wellness-program/id1339513631?mt=8") {
                let objectsToShare = [name]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
                self.present(activityVC, animated: true, completion: nil)
            }
            else
            {
                // show alert for not available
                self.showAlert(title: "Error", message: "Cannot share the application")
            }
        }
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
