

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
    var selectedSaveDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(selectedNomber)
        
         read()
        
        let dic = diaryList[selectedNomber] as! NSDictionary
        
        print(dic)
        
        myTitle?.text = dic["title"] as! String
   
        textToWrite?.text = dic["content"] as! String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy/MM/dd"
        
        let dateString: String = dateFormatter.string(from: (dic["startDate"] as! Date?)!)
        myDate?.text = dateString
        
        let dateString2: String = dateFormatter.string(from: (dic["endDate"] as! Date?)!)
        myDate2?.text = dateString2
        
        //画像角落とす
        self.firstImage.layer.cornerRadius = 35
        self.firstImage.layer.masksToBounds = true
        
        //画像枠線に色
        
//        self.firstImage.layer.borderColor = UIColor.blue.cgColor
//        self.firstImage.layer.borderWidth = 10

        
        //textfield枠線透明
        myTitle.borderStyle = .none
        myDate.borderStyle = .none
        myDate2.borderStyle = .none
        
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
            
            var i = 0
            
            //データの取得
            for result: AnyObject in fetchResults{
                
                let title: String? = result.value(forKey: "title") as? String
                let saveDate: Date? = result.value(forKey: "saveDate") as? Date
                let content: String? = result.value(forKey:"content") as? String
                let image1: String? = result.value(forKey: "image1") as? String
                let startDate: Date? = result.value(forKey: "startDate") as? Date
                let endDate: Date? = result.value(forKey: "endDate") as? Date
                
                diaryList.add(["title":title, "saveDate":saveDate,"image1":image1,"content":content,"startDate":startDate,"endDate":endDate])
                
                if saveDate == selectedSaveDate{
                    selectedNomber = i
                }
                
                i = i + 1

            }
        }catch{
        }
    }
    
   
    func deleteData(){
       
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let request:NSFetchRequest<DIARY> = DIARY.fetchRequest()
        
        //表示の時に使っているsavedateをdicに取ってくる
        //なんでか知らんけどsaveDateが何秒かずれてたから※本来なら以下２行不要
        let dic = diaryList[selectedNomber] as! NSDictionary
        selectedSaveDate = (dic["saveDate"] as! Date?)!

        //savedate取ってくる
        //saveDate取ってくるとそれに紐づいたデータ(ディクショナリ一個分)も取れるタイトルなどはかぶる可能性があるためsaveDateを取得
        let namePredicte = NSPredicate(format: "saveDate = %@", selectedSaveDate as CVarArg)
        
        request.predicate = namePredicte
        
        print(namePredicte)
        
        do{
            let fetchResults = try viewContext.fetch(request)
            
            for result: AnyObject in fetchResults{
                let record = result as! NSManagedObject
                
                //１行ずつ削除
                viewContext.delete(record)
            }
            
            try viewContext.save()
           
            //一個前のVCに戻る
            navigationController?.popToViewController(navigationController!.viewControllers[0], animated: true)
           
        }catch{            
        }
    }
    
    @IBAction func tapToDelete(_ sender: UIButton) {
        
        //TODO:削除
        let alertController = UIAlertController(title: "削除しますか？", message: "", preferredStyle: .alert)
        
        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in self.deleteData()
            print("OK")
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        // ③ UIAlertControllerにActionを追加
        alertController.addAction(cancelAction)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func tapToShare(_ sender: UIBarButtonItem) {
        
        //アクティビティービュー作成
        let controller = UIActivityViewController(activityItems: [firstImage.image], applicationActivities: nil)
        
        //アクティビティービュー表示
        present(controller, animated: true, completion: nil)

    }
    
    @IBAction func tapToBack(_ sender: UIButton) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
  }
