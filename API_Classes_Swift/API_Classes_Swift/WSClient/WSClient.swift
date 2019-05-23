//
//  WSClient.swift
//  Alamofier
//

import UIKit
import Alamofire
import AlamofireImage
import SystemConfiguration

enum WSRequestType : Int {
    case WSRequestTypeAppSettings = 0
}

enum WSAPI : String {
    case AppSettings                = "user/appsettinglist"
}

enum UploadImgType : Int {
    case profilePic = 1
    case coverPic
}

enum ImgPath : String {
    case ProfilePicPath = "user/updateuser"
    case CoverPicPath   = "Cover"
}

enum MultipartUploadStatus {
    case success(progress : Float, response : AnyObject?)
    case uploading(progress: Float)
    case failure(error : NSError?)
}



class WSClient: NSObject {
    
    static let sharedInstance : WSClient = {
        let instance = WSClient()
        instance.sessionMngr = SessionManager.init(configuration: URLSessionConfiguration.default)
        return instance
    }()
    
    //API Base URL
    let BaseURL = "PASTE API URL here"
    var sessionMngr : SessionManager!
    
    //Params Key
    let ParameterKey = "params" // REMOVE THIS IS API DOES NOT USE PARAMS
    
    //Session Manager
    
    //MARK:- Get API
    func getAPI(apiType : WSRequestType) -> String {
        switch apiType {
        case .WSRequestTypeAppSettings:
            return BaseURL+WSAPI.AppSettings.rawValue
        }
    }
    
    
    //MARK:- Convert Dictionary to Json
    func convertDictToJson(dict : NSDictionary) -> NSDictionary? {
        var jsonDict : NSDictionary!
        do {
            let jsonData = try JSONSerialization.data(withJSONObject:dict, options:[])
            let jsonDataString = String(data: jsonData, encoding: String.Encoding.utf8)!
            print("Post Request Params : \(jsonDataString)")
            jsonDict = [ParameterKey : jsonDataString]
            return jsonDict
        } catch {
            print("JSON serialization failed:  \(error)")
            jsonDict = nil
        }
        return jsonDict
    }
    
    //MARK:- Convert Array to Json
    func convertArrayToJson(array : NSArray, parameterKey : String) -> [String : AnyObject]? {
        var jsonDict : [String : AnyObject]?
        do {
            let jsonData = try JSONSerialization.data(withJSONObject:array, options:[])
            let jsonDataString = String(data: jsonData, encoding: String.Encoding.utf8)!
            jsonDict = [parameterKey : jsonDataString as AnyObject]
            return jsonDict
        } catch {
            print("JSON serialization failed:  \(error)")
            jsonDict = nil
        }
        return jsonDict
    }
    
    //MARK:- Cancel All Previous Request
    func cancelAllPreviousRequest() {        
        self.sessionMngr.session.getAllTasks { tasks in
            tasks.forEach { $0.cancel() }
        }
    }
    
    
    //MARK:- Post Request
    func postRequestForAPI(apiType : WSRequestType, parameters : [String : AnyObject]? = nil, completionHandler:@escaping (_ responseObject : NSDictionary?, _ error : NSError?) -> Void) {
        if !isConnectedToNetwork(){
            // NO NETWORK ALERT
            return
        }
        
        //        let configuration : URLSessionConfiguration = URLSessionConfiguration.default
        //        configuration.requestCachePolicy = .useProtocolCachePolicy
        //        configuration.timeoutIntervalForRequest = 35
        
        //        sessionMngr = SessionManager.init(configuration: configuration)
        
        //----------------------------------------------------------------
        
        let apipath : String = getAPI(apiType: apiType)
        
        do{
            if parameters != nil {
                let paramsData = try JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted)
                if let params = String(data: paramsData, encoding: .utf8) {
                    print("Post Requset json Params: \(params)")
                }
            }
        }
        catch let JSONError as NSError {
            print("\(JSONError)")
        }
        
        var apiParams : NSDictionary!
        
        if (parameters != nil){
            apiParams = convertDictToJson(dict: parameters! as NSDictionary)
        }
        
        print("Post Requset URL : \(apipath)")
        
        var appVersion: String? = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = version
        }
        
        let strHeaderToken : String? = ""
        let strDeviceToken : String? = ""
        
        let requestHeader: HTTPHeaders = ["header_token": strHeaderToken!,
                                          "device_type": "1",
                                          "device_token": strDeviceToken!,
                                          "app_version": appVersion!,
                                          "Accept": "application/json"]
        
        print("Post Request Header : \(String(describing: requestHeader))")
        
        
        
        //--------------------- Request API ------------------------------
        
        self.sessionMngr.request(apipath, method: .post, parameters: apiParams as? Parameters, headers: requestHeader) .responseJSON { response in
            switch(response.result) {
            case .success(_):
                do {
                    let JSON = try JSONSerialization.jsonObject(with: response.data! as Data, options:JSONSerialization.ReadingOptions(rawValue: 0))
                    
                    print("URL : \(apipath)")
                    
                    
                    guard let JSONDictionary: NSDictionary = JSON as? NSDictionary else {
                        print("Not a Dictionary")
                        return
                    }
                    
                    let jsonData = try JSONSerialization.data(withJSONObject: JSONDictionary, options: .prettyPrinted)
                    if let json = String(data: jsonData, encoding: .utf8){
                        print("Post json Response: \(json)")
                    }
                    
                    //                        if let status = Int(CommonUnit.stringFromAny(JSONDictionary[Constant.APIKeys.status] as AnyObject)){
                    //                            switch status {
                    //                            case Constant.APIStatusCode.success:
                    //                                if let badge = Int(CommonUnit.stringFromAny(JSONDictionary[Constant.APIKeys.badge_count] as AnyObject)){
                    //                                    CommonUnit.setBadgeCount(badgeCount: badge)
                    //                                }
                    //                                break
                    //                            case Constant.APIStatusCode.headerTokenExpire:
                    //                                switch apiType {
                    //                                    case .WSRequestTypeAppSettings,
                    //                                         .WSRequestTypeLogIn:
                    //                                    break
                    //                                default:
                    //                                    self.setLogInAfterTokenExpire(errorMsg: CommonUnit.stringFromAny(JSONDictionary[Constant.APIKeys.message]))
                    //                                    return
                    //                                }
                    //                            default:
                    //                                break
                    //                            }
                    //                        }
                    
                    completionHandler(JSONDictionary,nil)
                }
                catch let JSONError as NSError {
                    print("\(JSONError)")
                }
                break
            case .failure(_):
                print("failure Http: \(String(describing: response.result.error?.localizedDescription))")
                completionHandler(nil,response.result.error! as NSError)
                break
            }
        }
        
    }
    
    
    
    //MARK:- Get Request
    func getRequestForAPI(apiType : WSRequestType, completionHandler:@escaping (_ responseObject : NSDictionary?, _ error : NSError?) -> Void) {
        if !isConnectedToNetwork(){
            // NO NETWORK ALERT
            return
        }
        
        //        let configuration : URLSessionConfiguration = URLSessionConfiguration.default
        //        sessionMngr = SessionManager.init(configuration: configuration)
        
        //----------------------------------------------------------------
        
        let apipath : String = getAPI(apiType: apiType)
        
        print("Get Requset URL : \(apipath)")
        
        var appVersion: String? = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = version
        }
        
        let strHeaderToken : String? = ""
        let strDeviceToken : String? = ""
        
        let requestHeader: HTTPHeaders = ["header_token": strHeaderToken!,
                                          "device_type": "1",
                                          "device_token": strDeviceToken!,
                                          "app_version": appVersion!,
                                          "Accept": "application/json"]
        print("Get Request Header : \(String(describing: requestHeader))")
        
        //--------------------- Request API ------------------------------
        self.sessionMngr.request(apipath, method: .get, parameters: nil, encoding: URLEncoding.default, headers: requestHeader)
            .responseJSON { response in
                switch(response.result) {
                case .success(_):
                    do {
                        let JSON = try JSONSerialization.jsonObject(with: response.data! as Data, options:JSONSerialization.ReadingOptions(rawValue: 0))
                        guard let JSONDictionary: NSDictionary = JSON as? NSDictionary else {
                            print("Not a Dictionary")
                            return
                        }
                        
                        let jsonData = try JSONSerialization.data(withJSONObject: JSONDictionary, options: .prettyPrinted)
                        if let json = String(data: jsonData, encoding: .utf8){
                            print("Get json Response: \(json)")
                        }
                        
                        completionHandler(JSONDictionary,nil)
                    }
                    catch let JSONError as NSError {
                        print("\(JSONError)")
                    }
                    break
                case .failure(_):
                    print("failure Http: \(String(describing: response.result.error?.localizedDescription))")
                    completionHandler(nil,response.result.error! as NSError)
                    break
                }
        }
        
    }
    
    
    //MARK:- Put Request
    func putRequestForAPI(apiType : WSRequestType, parameters : [String : AnyObject]? = nil, completionHandler:@escaping (_ statusID : Int, _ responseObject : NSDictionary?, _ error : NSError? ) -> Void) {
        
        if !isConnectedToNetwork(){
            // NO ERROR ALERT
            return
        }
        
        let apipath : String = getAPI(apiType: apiType)
        //var jsonParams : [String : AnyObject]?
        var ApiParams : [String : AnyObject]?
        
        
        ApiParams = parameters
        
        
        
        do{
            if parameters != nil {
                let paramsData = try JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted)
                if let params = String(data: paramsData, encoding: .utf8) {
                    print("Put Requset json Params String: \(params)")
                }
            }
        }
        catch let JSONError as NSError {
            print("\(JSONError)")
            
        }
        
        
        let apiParams = convertDictToJson(dict: parameters! as NSDictionary)
        
        print("Put Requset JSON : \(apiParams)")
        print("Put Requset URL : \(apipath)")
        print("\n\nPut Requset Params: \(ApiParams!)")
        
        var appVersion: String? = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = version
        }
        
        let strHeaderToken : String? = ""
        let strDeviceToken : String? = ""
        
        let requestHeader: HTTPHeaders = ["header_token": strHeaderToken!,
                                          "device_type": "1",
                                          "device_token": strDeviceToken!,
                                          "app_version": appVersion!,
                                          "Accept": "application/json"]
        print("Get Request Header : \(String(describing: requestHeader))")
        
        print("Put Request Header : \(String(describing: requestHeader))")
        
        //--------------------- Request API ------------------------------
        //        let configuration : URLSessionConfiguration = URLSessionConfiguration.default
        //        sessionMngr = SessionManager.init(configuration: configuration)
        
        self.sessionMngr.request(apipath, method: .put, parameters: ApiParams, headers: requestHeader).responseJSON { response in
            //Alamofire.request(apipath, method: .put, parameters: ApiParams, encoding: URLEncoding.default, headers: requestHeader).responseJSON{ response in
            switch(response.response?.statusCode) {
                
            case 200:
                
                if (response.data?.count == 0){
                    completionHandler((response.response?.statusCode)!, nil, nil)
                }
                do {
                    
                    let JSON = try JSONSerialization.jsonObject(with: response.data! as Data, options:JSONSerialization.ReadingOptions(rawValue: 0))
                    guard let JSONDictionary: NSDictionary = JSON as? NSDictionary else {
                        print("Not a Dictionary")
                        return
                    }
                    print("Get Response : \(JSONDictionary)")
                    completionHandler((response.response?.statusCode)!,JSONDictionary,nil)
                    
                }
                catch let JSONError as NSError {
                    print("\(JSONError)")
                }
                break
            case 404:
                
                
                do {
                    let JSON = try JSONSerialization.jsonObject(with: response.data! as Data, options:JSONSerialization.ReadingOptions(rawValue: 0))
                    guard let JSONDictionary: NSDictionary = JSON as? NSDictionary else {
                        print("Not a Dictionary")
                        return
                    }
                    print("Get Response : \(JSONDictionary)")
                    completionHandler((response.response?.statusCode)!,JSONDictionary,nil)
                }
                catch let JSONError as NSError {
                    print("\(JSONError)")
                }
                
                
                print("failure Http: \(String(describing: response.response?.statusCode))")
                
                break
                
            default:
                do {
                    let JSON = try JSONSerialization.jsonObject(with: response.data! as Data, options:JSONSerialization.ReadingOptions(rawValue: 0))
                    guard let JSONDictionary: NSDictionary = JSON as? NSDictionary else {
                        print("Not a Dictionary")
                        return
                    }
                    print("Put Response forAPI \(apipath) : \(JSONDictionary)")
                    
                    completionHandler((response.response?.statusCode)!,JSONDictionary.value(forKey: "result") as? NSDictionary,nil)
                    
                }
                catch let JSONError as NSError {
                    print("\(JSONError)")
                }
                
                print("failure Http: \(String(describing: response.response?.statusCode))")
                
                break
            }
        }
        //-----------------------------------------------------------------
        
    }
    
    //MARK:- Get Image Upload Path
    func getImgUploadPath(imgType : UploadImgType) -> String{
        switch imgType{
        case .coverPic:
            return BaseURL+"Api/"+ImgPath.CoverPicPath.rawValue
        case .profilePic:
            return BaseURL+"Api/"+ImgPath.ProfilePicPath.rawValue
        }
    }
    
    //MARK:- Image Upload multipart
    func imageUploadFromURL(imgType: UploadImgType, strImage : String, parameter: [String:String]? = nil, completionHandler: @escaping (_ uploadStatus : MultipartUploadStatus) -> Void) {
        downloadImage(url: strImage) { (_ error : NSError?, _ image : UIImage?) -> Void in
            self.imageUpload(imgType: imgType, image: image!, parameter: parameter) { (_ imgUploadStatus) in
                completionHandler(imgUploadStatus)
            }
        }
    }
    
    
    
    func imageUpload(imgType: UploadImgType, image : UIImage, parameter: [String:String]? = nil, completionHandler: @escaping (_ uploadStatus : MultipartUploadStatus) -> Void) {
        
        if !isConnectedToNetwork(){
            // NO NETWORK ALERT
            return
        }
        
        //        let configuration : URLSessionConfiguration = URLSessionConfiguration.default
        //        sessionMngr = SessionManager.init(configuration: configuration)
        
        //--------------------- Request API ------------------------------
        func requestAPI(strUploadPath : String, imageData : Data, params : Parameters?, reqHeaders : HTTPHeaders){
            self.sessionMngr.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(imageData, withName: "filedata", fileName: "filedata.jpg", mimeType: "image/jpeg")
                print("mutlipart 1st \(multipartFormData)")
                if (params != nil){
                    for (key, value) in params! {
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
                    }
                    print("mutlipart 2nd \(multipartFormData)")
                }
            }, to:strUploadPath, method:.post, headers:reqHeaders)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
                        completionHandler(.uploading(progress: Float(Progress.fractionCompleted)))
                    })
                    
                    upload.responseJSON { response in
                        
                        if let JSON = response.result.value {
                            completionHandler(.success(progress: 1.0, response: JSON as! NSDictionary))
                            let JSONDictionary = JSON as! NSDictionary
                            //                            if let status = Int(CommonUnit.stringFromAny(JSONDictionary[Constant.APIKeys.status] as AnyObject)){
                            //                                switch status {
                            //                                case Constant.APIStatusCode.success:
                            //                                    if let badge = Int(CommonUnit.stringFromAny(JSONDictionary[Constant.APIKeys.badge_count] as AnyObject)){
                            //                                        CommonUnit.setBadgeCount(badgeCount: badge)
                            //                                    }
                            //                                    break
                            //                                case Constant.APIStatusCode.headerTokenExpire:
                            //                                    self.setLogInAfterTokenExpire(errorMsg: CommonUnit.stringFromAny(JSONDictionary[Constant.APIKeys.message]))
                            //                                    return
                            //                                default:
                            //                                    break
                            //                                }
                            //                            }
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    completionHandler(.failure(error: encodingError as NSError))
                }
            }
        }
        //----------------------------------------------------------------
        
        let uploadPath : String = getImgUploadPath(imgType: imgType)
        let imgData : Data = Data() //= UIImageJPEGRepresentation(image, 1.0)!
        
        var appVersion: String? = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = version
        }
        
        let strHeaderToken : String? = ""
        let strDeviceToken : String? = ""
        
        let requestHeader: HTTPHeaders = ["header_token": strHeaderToken!,
                                          "device_type": "1",
                                          "device_token": strDeviceToken!,
                                          "app_version": appVersion!,
                                          "Accept": "application/json"]
        
        var apiParams : NSDictionary!
        
        if (parameter != nil)
        {
            apiParams = convertDictToJson(dict: parameter! as NSDictionary)
        }
        
        print("Params : \(String(describing: apiParams)) and Header : \(requestHeader)")
        
        requestAPI(strUploadPath: uploadPath, imageData: imgData, params: apiParams as? Parameters, reqHeaders: requestHeader)
        
    }
    
    //MARK:- Image Downloader
    func downloadImage(url: String, completionHandler: @escaping (_ error: NSError?, _ image:UIImage?)-> Void)
    {
        if url.isEmpty {
            completionHandler(nil,nil)
            return
        }
        
        if !isConnectedToNetwork(){
            // NO NETWORK ALERT
            return
        }
        
        //        let configuration : URLSessionConfiguration = URLSessionConfiguration.default
        //        sessionMngr = SessionManager.init(configuration: configuration)
        
        //--------------------- Request API ------------------------------
        func requestAPI(){
            self.sessionMngr.request(url)
                .downloadProgress { progress in
                    print("Download Progress: \(progress.fractionCompleted)")
                }
                .responseData { response in
                    if let data = response.result.value {
                        let image = UIImage(data: data)
                        completionHandler(nil,image)
                    }else{
                        completionHandler(nil,nil)
                    }
            }
        }
        //----------------------------------------------------------------
        
        requestAPI()
        
    }
    
    
    
    //MARK:- Check Network Reachability
    /// Check if user is connected to internet or not
    ///
    /// - Returns: Returns true if connected else returns false
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
    }
}


extension UIImage {
    
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resizedTo200Kb() -> Data? {
        //        CommonUnit.progressHUD(.show)
        guard let imageData = self.pngData() else { return nil }
        
        var resizingImage = self
        var finalImgData : Data? = resizingImage.pngData()
        var imageSizeKB = Double(imageData.count) / 1000.0 // ! Or devide for 1024 if you need KB but not kB
        
        while imageSizeKB > 200 { // ! Or use 1024 if you need KB but not kB
            guard let resizedImage = resizingImage.resized(withPercentage: 0.9),
                let imageData = resizedImage.pngData()
                else { return nil }
            
            resizingImage = resizedImage
            finalImgData = imageData
            imageSizeKB = Double(imageData.count) / 1000.0 // ! Or devide for 1024 if you need KB but not kB
        }
        
        //        CommonUnit.progressHUD(.dismiss)
        return finalImgData
    }
}
