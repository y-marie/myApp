

import UIKit
import CoreData
import Photos

class showDiaryViewController: UIViewController {

    @IBOutlet weak var myTitle: UITextField!
    @IBOutlet weak var myDate: UITextField!
    @IBOutlet weak var myDate2: UITextField!
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var textToWrite: UITextView!
    
    var diaryList = NSMutableArray()
    
    var selectedNomber:Int = -1
    var scdiaryList:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(selectedNomber)
        
         read()
        
        let dic = diaryList[selectedNomber] as! NSDictionary
        
        print(dic)
        myTitle?.text = dic["title"] as! String
        
   //辞書から引っ張るコード
   //date分割しちゃったけど...
        //  myDate?.text = dic[""] as! String
   
        textToWrite?.text = dic["date"] as! String
        
        let strURL =  dic["image1"] as! String
        if strURL != nil{
            
            let url = URL(string: strURL as String!)
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(withALAssetURLs: [url!], options: nil)
            let asset: PHAsset = (fetchResult.firstObject! as PHAsset)
            let manager: PHImageManager = PHImageManager()
                manager.requestImage(for: asset,targetSize: CGSize(width: 5, height: 500),contentMode: .aspectFill,options: nil) { (image, info) -> Void in
                self.firstImage.image = image
            }
            
        }
        
        print(diaryList)
        
    }

    func read(){
        
        diaryList = NSMutableArray()
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let myRequest = NSEntityDescription.entity(forEntityName: "DIARY", in: viewContext)
        
        let query: NSFetchRequest<DIARY> = DIARY.fetchRequest()
        
        do{
            //データを一括取得
            let fetchResults = try viewContext.fetch(query)
            
            //データの取得
            for result: AnyObject in fetchResults{
                
                let title: String? = result.value(forKey: "title") as? String
                let saveDate: Date? = result.value(forKey: "saveDate") as? Date
                let content: String? = result.value(forKey:"content") as? String
                let image1: String? = result.value(forKey: "image1") as? String
                let image2: String? = result.value(forKey: "image2") as? String
                let date: Date? = result.value(forKey: "date") as? Date
                
                //("title:\(title) saveDate:\(saveDate)")
                
                diaryList.add(["title":title, "saveDate":saveDate,"image1":image1,"image2":image2,"date":date,"content":content])
            }
        }catch{
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
  }
