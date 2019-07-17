
import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var cltView: UICollectionView?
    @IBOutlet weak var lblTitle: UILabel?
    @IBOutlet weak var btnSeeAll: UIButton?

    var gamesM : GameListingM?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        layout.itemSize = CGSize(width: self.frame.size.width - 50, height: self.frame.size.height)
//        cltView?.collectionViewLayout = layout
        
        cltView?.register(UINib(nibName: "ListInnerCell", bundle: nil), forCellWithReuseIdentifier: "ListInnerCell")
        cltView?.delegate = self
        cltView?.dataSource = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension TableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        //return CGSize(width: UIScreen.main.bounds.size.width-50, height: 200)
        return CGSize(width: self.frame.size.width-100, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gamesM?.feed?.newGameList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListInnerCell", for: indexPath) as! ListInnerCell
        
        let model = gamesM?.feed?.newGameList?[indexPath.item]
        

        cell.lblTitle?.text = model?.name
        cell.lblSubTitle?.text = model?.artistName
        self.setImageWithURL(strURL: model?.artworkUrl100, imgView: cell.imgView, placeHolder: nil)
        
        cell.imgView?.layer.masksToBounds = true
        cell.imgView?.layer.cornerRadius = 5
        cell.btnGet?.layer.cornerRadius = (cell.btnGet?.frame.size.height)!/2
        cell.imgView?.roundCornersForAspectFit(radius: 10)


        return cell
        
        
    }
    
    //MARK:- Set Image in ImageView Method
    //
    // - Parameter strURL : String
    // - Parameter imageView : UIImageView
    // - Parameter placeHolder Image : UIImage
    func setImageWithURL(strURL : String?, imgView : UIImageView?, placeHolder : UIImage?) {
        if strURL != nil {
            let imgURL = NSURL(string: strURL!)
            if imgURL != nil {
                imgView?.af_setImage(withURL: imgURL! as URL, placeholderImage: placeHolder, filter: nil, progress: nil, progressQueue: .main, imageTransition: .noTransition, runImageTransitionIfCached: false, completion: { (response) in })
            }else{
                imgView?.image = placeHolder
            }
        }else{
            imgView?.image = placeHolder
        }
    }
    
}
