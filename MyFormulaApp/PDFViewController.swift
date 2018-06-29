//
//  PDFViewController.swift
//  MyFormulaApp
//
//  Created by Apple on 21/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import PDFKit
import MBProgressHUD
import GoogleMobileAds


class PDFViewController: UIViewController,GADInterstitialDelegate{

    @IBOutlet var pdfView: PDFView!
    
    @IBOutlet var MenuView: UIView!
 
    @IBOutlet var lblHeaderTitle: UILabel!
    
    var urlString = String()
    var Headertitle = String()
    
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MenuView.addBorderShadow(shadowOpacity: 0.5, shadowRadius: 5, shadowColor: UIColor.black)
        
        lblHeaderTitle.text = Headertitle
        
        interstitial = createAndLoadInterstitial()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        //let url = URL(string: "http://barodacoders.com/formula/fileupload/server/php/files/gemp110.pdf")
        
        let Spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
        //Spinner.mode = .determinateHorizontalBar
        
        let url = URL(string: urlString)
        
        Spinner.hide(animated: true)
        
        let pdfDocument = PDFDocument(url: url!)
        pdfView.document = pdfDocument
        pdfView.displayDirection = .vertical
        pdfView.autoScales = true
        
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
