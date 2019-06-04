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



//MARK:- Set Image in ImageView Method
///
/// - Parameter strURL : String
/// - Parameter imageView : UIImageView
/// - Parameter placeHolder Image : UIImage
//class func setImageWithURL(strURL : String?, imgView : UIImageView?, placeHolder : UIImage?) {
//    if strURL != nil {
//        let imgURL = NSURL(string: strURL!)
//        if imgURL != nil {
//            imgView?.af_setImage(withURL: imgURL! as URL, placeholderImage: placeHolder, filter: nil, progress: nil, progressQueue: .main, imageTransition: .noTransition, runImageTransitionIfCached: false, completion: { (response) in })
//        }else{
//            imgView?.image = placeHolder
//        }
//    }else{
//        imgView?.image = placeHolder
//    }
//}
//
////MARK:- Set Image in UIButton Method
/////
///// - Parameter strURL : String
///// - Parameter imageView : UIImageView
///// - Parameter placeHolder Image : UIImage
//class func setImageWithURL(strURL : String?, btn : UIButton?, placeHolder : UIImage?) {
//    if strURL != nil {
//        let imgURL = NSURL(string: strURL!)
//        if imgURL != nil {
//            if placeHolder != nil {
//                btn?.af_setBackgroundImage(for: .normal, url: imgURL! as URL, placeholderImage: placeHolder, filter: nil, progress: nil, progressQueue: .main, completion: { (response) in
//                })
//                btn?.imageView?.contentMode = .scaleAspectFill
//            }else{
//                btn?.af_setBackgroundImage(for: .normal, url: imgURL! as URL)
//                btn?.imageView?.contentMode = .scaleAspectFill
//            }
//        }else{
//            btn?.setImage(placeHolder, for: .normal)
//            btn?.imageView?.contentMode = .scaleAspectFill
//        }
//    }else{
//        btn?.setImage(placeHolder, for: .normal)
//        btn?.imageView?.contentMode = .scaleAspectFill
//    }
//}
