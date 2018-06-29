//
//  DashBoardViewController.swift
//  MyFormulaApp
//
//  Created by Apple on 21/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import Alamofire
import SwiftyJSON
import MBProgressHUD
import SDWebImage
import GoogleMobileAds

var SubjectListData = JSON()

class DashBoardViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,GADInterstitialDelegate {
    
    
    @IBOutlet var DashBoardCollectionView: UICollectionView!
    
    @IBOutlet var MenuView: UIView!
    
    var interstitial: GADInterstitial!
    
    
    let subjectlist = ["Maths","Physics","Chemistry","Biology","Maths","Physics","Chemistry","Biology","Maths","Physics","Chemistry","Biology","Maths","Physics","Chemistry","Biology"]
    
    let images = ["calculation","magnet","flask","biology","calculation","magnet","flask","biology","calculation","magnet","flask","biology","calculation","magnet","flask","biology"]
    
    //let colorArray:[UIColor] = [UIColor(red: 230/255, green: 103/255, blue: 96/255, alpha: 1.0),UIColor(red: 140/255, green: 136/255, blue: 205/255, alpha: 1.0),UIColor(red: 105/255, green: 197/255, blue: 228/255, alpha: 1.0),UIColor(red: 255/255, green: 223/255, blue: 139/255, alpha: 1.0),UIColor(red: 97/255, green: 224/255, blue: 100/255, alpha: 1.0),UIColor(red: 255/255, green: 194/255, blue: 229/255, alpha: 1.0),UIColor(red: 255/255, green: 170/255, blue: 170/255, alpha: 1.0),UIColor(red: 194/255, green: 255/255, blue: 0/255, alpha: 1.0)]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        MenuView.addBorderShadow(shadowOpacity: 0.5, shadowRadius: 5, shadowColor: UIColor.black)
        
        DashBoardCollectionView.delegate = self
        DashBoardCollectionView.dataSource = self
        
        
        
        loadData()
        
        interstitial = createAndLoadInterstitial()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //interstitial = createAndLoadInterstitial()
        
        //loadData()
        
    }
   
    //------------------- Google Interstetial Ads --------------------------
    
    private func createAndLoadInterstitial() -> GADInterstitial? {
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-8501671653071605/2568258533")
        
        guard let interstitial = interstitial else {
            return nil
        }
        
        let request = GADRequest()
        
        // Remove the following line before you upload the app
        //request.testDevices = [ kGADSimulatorID ]
        
        interstitial.load(request)
        interstitial.delegate = self
        
        return interstitial
    }
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        
        print("Interstitial loaded successfully")
        ad.present(fromRootViewController: self)
    }
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        
        print("Fail to receive interstitial")
    }
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        
        //interstitial = createAndLoadInterstitial()
    }
    
    //-----------------------------------------------------------------------
    
    @IBAction func btnMenuAction(_ sender: UIButton) {
        
        let slidemenu = self.slideMenuController()
        
        slidemenu?.openLeft()
        
    }
    @IBAction func btnSearch(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let allTopicsSearchViewController = storyboard.instantiateViewController(withIdentifier: "allTopicsSearchViewController") as! AllTopicsSearchViewController
        allTopicsSearchViewController.TopicList = SubjectListData["subject_list"]
        self.present(allTopicsSearchViewController, animated: false, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //return subjectlist.count
        
        return SubjectListData["subject_list"].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = DashBoardCollectionView.dequeueReusableCell(withReuseIdentifier: "dashBoardCollectionViewCell", for: indexPath) as! DashBoardCollectionViewCell
        
        cell.CellView.addBorderShadowDown(shadowOpacity: 0.3, shadowRadius: 1.0, shadowColor: UIColor.gray)
        cell.CellView.backgroundColor = colorArray[indexPath.row % colorArray.count]
        
        //cell.lblSubjectName.roundCorners([.bottomRight, .bottomLeft], radius: 10)
        
        cell.lblSubjectName.clipsToBounds = true
        cell.lblSubjectName.layer.cornerRadius = 10
        cell.lblSubjectName.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        
        
        //cell.lblSubjectName.text = subjectlist[indexPath.row]
        //cell.imgSubject.image = UIImage(named: images[indexPath.row])
        
        cell.lblSubjectName.text = SubjectListData["subject_list"][indexPath.row]["subject_title"].stringValue
        cell.imgSubject.sd_setImage(with: URL(string: SubjectListData["subject_list"][indexPath.row]["subject_img"].stringValue), placeholderImage: UIImage(named: "placeholder"))
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let subjectViewController = storyboard.instantiateViewController(withIdentifier: "subjectViewController") as! SubjectViewController
        subjectViewController.SubjectDetails = SubjectListData["subject_list"][indexPath.row]
        subjectViewController.SubTopicFlag = 0
        self.present(subjectViewController, animated: true, completion: nil)
    }
    
    func loadData()
    {
        let Spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let getSubjectListParameter : Parameters = [:]
        
        //print(getSubjectListParameter)
        
        Alamofire.request(subjectListAPI, method: .post, parameters: getSubjectListParameter, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            if(response.result.value != nil)
            {
                
                print(JSON(response.result.value))
                
               SubjectListData = JSON(response.result.value!)
                
                if(SubjectListData["status_code"].intValue == 1)
                {
                    Spinner.hide(animated: true)
                    self.DashBoardCollectionView.reloadData()
                    
                }
                    
                else
                {
                    Spinner.hide(animated: true)
                    self.showAlert(title: "Alert", message: "Something went wrong!.Please try again")
                }
            }
            else
            {
                Spinner.hide(animated: true)
                self.showAlert(title: "Alert", message: "Something went wrong! Please Check Your Internet Connection")
            }
            
        })
        
        
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
