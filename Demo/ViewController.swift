

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tblView: UITableView?
    
    var gamesM : GameListingM?
    var newM : GameListingM?
    var topFreeM : GameListingM?
    var topPaidM : GameListingM?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getNewGamesWeLove()
        getNewAppsWeLove()
        getTopFree()
        getTopPaid()
    }

    
    
    func getNewGamesWeLove() {
        WSClient.sharedInstance.getRequestForAPI(apiType: .WSRequestTypeNewGamesWeLove) { (response, error) in
            if error == nil{
                
                self.gamesM = GameListingM.init(object: response as Any)
                self.tblView?.reloadData()
                // Success
                // Constant.Models.appSettings = AppSettings.init(object: response?[Constant.APIKeys.result] as Any)
                
            }else{
                // ERROR ALERT
            }
        }
    }
    
    
    func getNewAppsWeLove() {
        WSClient.sharedInstance.getRequestForAPI(apiType: .WSRequestTypeNewAppsWeLove) { (response, error) in
            if error == nil{
                self.newM = GameListingM.init(object: response as Any)
                self.tblView?.reloadData()

                // Success
                // Constant.Models.appSettings = AppSettings.init(object: response?[Constant.APIKeys.result] as Any)
                
            }else{
                // ERROR ALERT
            }
        }
    }
    
    func getTopFree() {
        WSClient.sharedInstance.getRequestForAPI(apiType: .WSRequestTypeTopFree) { (response, error) in
            if error == nil{
                self.topFreeM = GameListingM.init(object: response as Any)
                self.tblView?.reloadData()

                // Success
                // Constant.Models.appSettings = AppSettings.init(object: response?[Constant.APIKeys.result] as Any)
                
            }else{
                // ERROR ALERT
            }
        }
    }
    
    func getTopPaid() {
        WSClient.sharedInstance.getRequestForAPI(apiType: .WSRequestTypeTopPaid) { (response, error) in
            if error == nil{
                self.topPaidM = GameListingM.init(object: response as Any)
                self.tblView?.reloadData()

                // Success
                // Constant.Models.appSettings = AppSettings.init(object: response?[Constant.APIKeys.result] as Any)
                
            }else{
                // ERROR ALERT
            }
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "TableViewCell"
        var cell : TableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? TableViewCell
        
        if (cell == nil) {
            let arr : NSArray = Bundle.main.loadNibNamed(identifier, owner: self, options: nil)! as NSArray
            cell = arr[0] as? TableViewCell
            cell.selectionStyle = .none
        }
        
        switch indexPath.row {
        case 0:
            cell.gamesM = gamesM
        case 1:
            cell.gamesM = newM
        case 2:
            cell.gamesM = topFreeM
        case 3:
            cell.gamesM = topPaidM
        default:
            break
        }
        
        cell.lblTitle?.text = cell.gamesM?.feed?.title

        cell.cltView?.reloadData()
        return cell
    }
    
    
    
    
}
