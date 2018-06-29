//
//  AllTopicsSearchViewController.swift
//  MyFormulaApp
//
//  Created by Apple on 26/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class AllTopicsSearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource , UISearchBarDelegate {
    
    var TopicList = JSON()
   
    var AlltopicsArray = JSON()
    
    var tempalltopics = [Any]()
    
    var filteredTempDict = JSON()

    @IBOutlet var AllTopicsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(TopicList)
        
        AllTopicsTableView.delegate = self
        AllTopicsTableView.dataSource = self
        
        for i in 0...TopicList.count-1
        {
            let tempsub = TopicList[i]
            
            //print(tempsub)
            
            for topic in tempsub["topic_list"]
            {
                //print(topic.1)
                
                //tempalltopics.append(JSON(topic.1))
                
                if(topic.1["sub_topic_list"].count != 0)
                {
                    for subtopic in topic.1["sub_topic_list"]
                    {
                        //print(subtopic.1)
                        
                        //AlltopicsArray.appendIfArray(json: JSON(subtopic.1))
                        
                        let dict:JSON = [
                            
                            "Topic_Name" : topic.1["topic_title"],
                            "Subject_Name" : tempsub["subject_title"]
                            
                        ]
                        var newsubtopic = subtopic.1
                        newsubtopic = try! newsubtopic.merged(with: dict)
                        print(newsubtopic)
                        
                        tempalltopics.append(JSON(newsubtopic))
                        
                        //subtopic.1 = try! subtopic.1.merged(with: dict)
                        //tempalltopics.append(JSON(subtopic.1))
                    }
                    
                }
                else
                {
                    let dict:JSON = [
                        
                        //"Topic_Name" : topic.1["topic_title"],
                        "Subject_Name" : tempsub["subject_title"]
                        
                    ]
                    
                    var newtopic = topic.1
                    newtopic = try! newtopic.merged(with: dict)
                    print(newtopic)
                    
                    tempalltopics.append(JSON(newtopic))
                    
                    //tempalltopics.append(JSON(topic.1))
                    
                }
                
            }
            
        }
        
        AlltopicsArray = JSON(tempalltopics)
        print(AlltopicsArray)
        
        filteredTempDict = AlltopicsArray
        
        searchBar()
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return AlltopicsArray.count
        
        return filteredTempDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = AllTopicsTableView.dequeueReusableCell(withIdentifier: "subjectTableViewCell", for: indexPath) as! SubjectTableViewCell
        
        cell.selectionStyle = .none
        
        //cell.lblTopicName.text = AlltopicsArray[indexPath.row]["topic_title"].stringValue
        
        //let temp = AlltopicsArray[indexPath.row]["topic_title"].stringValue
        
        //cell.lblTopicInitials.text = String(temp.first!)
        
        
        cell.lblTopicName.text = filteredTempDict[indexPath.row]["topic_title"].stringValue
        
        let temp = filteredTempDict[indexPath.row]["topic_title"].stringValue
        
        cell.lblTopicInitials.text = String(temp.first!)
        
        cell.lblMainTopicSubject.text = "Subject : " + filteredTempDict[indexPath.row]["Subject_Name"].stringValue
        
        if(filteredTempDict[indexPath.row]["Topic_Name"].exists())
        {
            cell.lblMainTopicSubject.text = "Subject : " + filteredTempDict[indexPath.row]["Subject_Name"].stringValue + "     " + "Topic : " + filteredTempDict[indexPath.row]["Topic_Name"].stringValue + "     "
        }
        
        
        cell.lblTopicInitials.backgroundColor = colorArray[indexPath.row % colorArray.count]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
            
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
        
        self.AllTopicsTableView.tableHeaderView = searchbar
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == ""
        {
            //list = tempList!
            
            filteredTempDict = []
            
            filteredTempDict = AlltopicsArray
            
            AllTopicsTableView.reloadData()
        }
        else
        {
            
            filteredTempDict = []
            
                for item in AlltopicsArray
                {
                    //print(item)
            
                    //let x = item.1["topic_title"].string?.lowercased()
                    //print(x)
                    
                    //let r = x?.contains(searchText.lowercased())
                    //print(r)
                    
                    if ((item.1["topic_title"].string?.lowercased().contains(searchText.lowercased()))!   ||  (item.1["Subject_Name"].string?.lowercased().contains(searchText.lowercased()))!)
                    {
                        filteredTempDict.appendIfArray(json: JSON(item.1))
                        
                        AllTopicsTableView.reloadData()
                    }
                    else if(item.1["Topic_Name"].exists() && (item.1["Topic_Name"].string?.lowercased().contains(searchText.lowercased()))!)
                    {
                        filteredTempDict.appendIfArray(json: JSON(item.1))
                        
                        AllTopicsTableView.reloadData()
                    }
                    else
                    {
                        //filteredTempDict = []
                    }
                }
        }
        
    }
    
    @objc func cancelPicker(){
        
        self.view.endEditing(true)
        
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
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
