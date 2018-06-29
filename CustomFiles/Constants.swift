//
//  Constants.swift
//  MyFormulaApp
//
//  Created by Apple on 21/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit


let colorArray:[UIColor] = [UIColor(red: 230/255, green: 103/255, blue: 96/255, alpha: 1.0),UIColor(red: 140/255, green: 136/255, blue: 205/255, alpha: 1.0),UIColor(red: 105/255, green: 197/255, blue: 228/255, alpha: 1.0),UIColor(red: 255/255, green: 223/255, blue: 139/255, alpha: 1.0),UIColor(red: 97/255, green: 224/255, blue: 100/255, alpha: 1.0),UIColor(red: 255/255, green: 194/255, blue: 229/255, alpha: 1.0),UIColor(red: 255/255, green: 170/255, blue: 170/255, alpha: 1.0),UIColor(red: 194/255, green: 255/255, blue: 0/255, alpha: 1.0)]


//Userdatas

let userDefault = UserDefaults.standard


//Contants

let deviceId = "deviceId"
let DeviceToken = "DeviceToken"

//Apis

let baseURL = "http://barodacoders.com/formula/index.php/api"
let registerAPI = "\(baseURL)/user/user_register"
let subjectListAPI = "\(baseURL)/user/subject_list"

