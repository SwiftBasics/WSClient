//
//  ViewController.swift
//  API_Classes_Swift
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func call_GET_API(_ sender: Any) {
        WSClient.sharedInstance.getRequestForAPI(apiType: .WSRequestTypeAppSettings) { (response, error) in
            if error == nil{
                
                // Success
                // Constant.Models.appSettings = AppSettings.init(object: response?[Constant.APIKeys.result] as Any)
                
            }else{
                // ERROR ALERT
            }
        }
    }
    
    @IBAction func call_POST_API(_ sender: Any) {
        callSettingsAPI()
    }
    
    //MARK:- Call Settings API
    func callSettingsAPI() {
        
        WSClient.sharedInstance.postRequestForAPI(apiType: .WSRequestTypeAppSettings, parameters: nil) { (response, error) in
            if error == nil{
                
                // Success
                // Constant.Models.appSettings = AppSettings.init(object: response?[Constant.APIKeys.result] as Any)
                
            }else{
                // ERROR ALERT
            }
        }
    }
}

