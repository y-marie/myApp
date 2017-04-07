

import UIKit
import CoreData

class showDiaryViewController: UIViewController {

    @IBOutlet weak var myTitle: UITextField!
    @IBOutlet weak var myDate: UITextField!
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var scImage: UIImageView!
    @IBOutlet weak var textToWrite: UITextView!
    
    var diaryList = NSMutableArray()
    
    var selectedNomber:Int = -1
    var scdiaryList:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(selectedNomber)
        
         read()
        
        let dic = diaryList[selectedNomber] as! NSDictionary
        myTitle?.text = dic["title"] as! String
        
        
        print(diaryList)
        
//        let dic = diaryList[1] as! NSDictionary
//        myTitle?.text = dic["title"] as! String
        

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
