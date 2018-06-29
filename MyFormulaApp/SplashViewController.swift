//
//  SplashViewController.swift
//  MyFormulaApp
//
//  Created by Apple on 22/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

import UserNotifications

import Firebase
import FirebaseInstanceID
import FirebaseMessaging

import GoogleMobileAds

class SplashViewController: UIViewController,GADInterstitialDelegate {

    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       RegisterUser()
    
        //interstitial = createAndLoadInterstitial()
        
        // Do any additional setup after loading the view.
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
    
    
    
    func RegisterUser()
    {
        let Spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
        userDefault.set(UIDevice.current.identifierForVendor?.uuidString, forKey: deviceId)
        
        var registerParameter = Parameters()
        
        if(userDefault.value(forKey: DeviceToken) == nil)
        {
            registerParameter = ["device_id": userDefault.value(forKey: deviceId) as! String,"device_type":2,"device_token": 123456]
        }
        else
        {
            registerParameter = ["device_id": userDefault.value(forKey: deviceId) as! String,"device_type":2,"device_token": userDefault.value(forKey: DeviceToken) as! String]
        }
        
        
        print(registerParameter)
        
        Alamofire.request(registerAPI, method: .post, parameters: registerParameter, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            if(response.result.value != nil)
            {
                
                print(JSON(response.result.value))
                
                let tempDict = JSON(response.result.value!)
                
                if(tempDict["status_code"].intValue == 0 || tempDict["status_code"].intValue == 1)
                {
                    Spinner.hide(animated: true)
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let slideViewController = storyboard.instantiateViewController(withIdentifier: "slideViewController") as! SlideViewController
                    
                    self.present(slideViewController, animated: true, completion: nil)
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
    
   
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    
    //--------------------------------------- Push Notification module End ---------------------------------------------------------------------------------------------------
    
    

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
