//
//  SubjectViewController.swift
//  MyFormulaApp
//
//  Created by Apple on 21/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage


class SubjectViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    var list = ["Quantam Mechanics","Nano Physics","Algebra","Arithematic","Thermodynamics","Organic Chemistry","Quantam Mechanics","Nano Physics","Algebra","Arithematic","Thermodynamics","Organic Chemistry","Quantam Mechanics","Nano Physics","Algebra","Arithematic","Thermodynamics","Organic Chemistry"]

    
    var tempList : [String]? = nil
    
    @IBOutlet var SubjectTableView: UITableView!
    
    @IBOutlet var MenuView: UIView!
    
    @IBOutlet var lblHeaderName: UILabel!
    
    var SubjectDetails = JSON()
    var filteredTempDict = JSON()
    
    var SubTopicFlag = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //tempList = list
        
        if(SubTopicFlag == 0)
        {
            filteredTempDict = SubjectDetails["topic_list"]
            lblHeaderName.text = SubjectDetails["subject_title"].stringValue
        }
        else
        {
            filteredTempDict = SubjectDetails["sub_topic_list"]
            lblHeaderName.text = SubjectDetails["topic_title"].stringValue
        }
        
        
        //filteredTempDict = SubjectDetails["topic_list"]
        
        SubjectTableView.delegate = self
        SubjectTableView.dataSource = self
        
        MenuView.addBorderShadow(shadowOpacity: 0.5, shadowRadius: 5, shadowColor: UIColor.black)
        
        searchBar()
        
    
        
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return list.count
        
        //return SubjectDetails["topic_list"].count
        
        return filteredTempDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = SubjectTableView.dequeueReusableCell(withIdentifier: "subjectTableViewCell", for: indexPath) as! SubjectTableViewCell
        
        cell.selectionStyle = .none
        
        //cell.lblTopicName.text = list[indexPath.row]
        
        //let temp = list[indexPath.row]
        
        //cell.lblTopicInitials.text = String(temp.first!)
        
        cell.lblTopicInitials.backgroundColor = colorArray[indexPath.row % colorArray.count]
        
        cell.lblTopicName.text = filteredTempDict[indexPath.row]["topic_title"].stringValue
        
        let temp = filteredTempDict[indexPath.row]["topic_title"].stringValue
        
        cell.lblTopicInitials.text = String(temp.first!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(filteredTempDict[indexPath.row]["sub_topic_list"].count != 0)
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let subjectViewController = storyboard.instantiateViewController(withIdentifier: "subjectViewController") as! SubjectViewController
    
            subjectViewController.SubjectDetails = filteredTempDict[indexPath.row]
            subjectViewController.SubTopicFlag = 1
            
            self.present(subjectViewController, animated: true, completion: nil)
        }
        else
        {
            print(filteredTempDict)
            
            if(filteredTempDict[indexPath.row]["pdf_url"] != JSON.null)
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let pdfViewController = storyboard.instantiateViewController(withIdentifier: "pdfViewController") as! PDFViewController
                pdfViewController.urlString = filteredTempDict[indexPath.row]["pdf_url"].stringValue
                pdfViewController.Headertitle = filteredTempDict[indexPath.row]["topic_title"].stringValue
                self.present(pdfViewController, animated: true, completion: nil)
            }
            else
            {
                self.showAlert(title: "No Pdf", message: "There is no pdf for this topic")
            }
            
        }
       
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    func searchBar()
    {
       
        let searchbar = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        searchbar.delegate = self
        searchbar.tintColor = UIColor.lightGray
        
        
        var doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        var flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        var done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(cancelPicker))
        
        var items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = items as! [UIBarButtonItem]
        doneToolbar.sizeToFit()
        
        
        searchbar.inputAccessoryView = doneToolbar
        
        self.SubjectTableView.tableHeaderView = searchbar
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == ""
        {
            //list = tempList!
            
            if(SubTopicFlag == 0)
            {
                filteredTempDict = SubjectDetails["topic_list"]
            }
            else
            {
                filteredTempDict = SubjectDetails["sub_topic_list"]
            }
            SubjectTableView.reloadData()
        }
        else
        {
            
            filteredTempDict = []
            
            if(SubTopicFlag == 0)
            {
                for item in SubjectDetails["topic_list"]
                {
                    print(item)
                    
                    let x = item.1["topic_title"].string?.lowercased()
                    print(x)
                    
                    let r = x?.contains(searchText.lowercased())
                    print(r)
                    
                    if (item.1["topic_title"].string?.lowercased().contains(searchText.lowercased()))!
                    {
                        filteredTempDict.appendIfArray(json: JSON(item.1))
                        
                        SubjectTableView.reloadData()
                    }
                    
                }
                
            }
            else
            {
                for item in SubjectDetails["sub_topic_list"]
                {
                    print(item)
                    
                    let x = item.1["topic_title"].string?.lowercased()
                    print(x)
                    
                    let r = x?.contains(searchText.lowercased())
                    print(r)
                    
                    if (item.1["topic_title"].string?.lowercased().contains(searchText.lowercased()))!
                    {
                        filteredTempDict.appendIfArray(json: JSON(item.1))
                        
                        SubjectTableView.reloadData()
                    }
                    
                }
            }
            
 
            
            /*
            list = []
            
            for item in tempList!
            {
                print(item)
                
                
                
                let x = item.lowercased()
                print(x)
                
                let r = x.contains(searchText.lowercased())
                print(r)
                
                if (item.lowercased().contains(searchText.lowercased()))
                {
                    //list.appendIfArray(json: JSON(item.1))
                    
                    list.append(item)
                    
                    SubjectTableView.reloadData()
                }
                
            }
            */
        }
        
    }
    
    @objc func cancelPicker(){
        
        self.view.endEditing(true)
        
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
