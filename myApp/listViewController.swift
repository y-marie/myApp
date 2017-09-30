

import UIKit
import CoreData

class listViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTableView: UITableView!
    
     var diaryList = NSMutableArray()
    
    //メンバ変数
    var selectedIndex = -1
    
    // 絞り込み削除に使用
    var dcSelectedDate = Date()
    // 
    var SaveDate:[Date] = []
    
    
    //一度だけのやつな
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //なんども呼ばれるやつな
    override func viewWillAppear(_ animated: Bool) {
        read()
    }
    
    //すでに存在するデータの読み込み処理
    func read(){
        
        //配列初期化
        diaryList = NSMutableArray()
        
        //AppDelegateを使う準備をしておく
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext
        
        //どのエンティティからdataを取得してくるか設定
        let query: NSFetchRequest<DIARY> = DIARY.fetchRequest()
        
        do{
            //データを一括取得
            let fetchResults = try viewContext.fetch(query)
            
            //データの取得
            for result: AnyObject in fetchResults{
                
                let title: String? = result.value(forKey: "title") as? String
                let image1: String? = result.value(forKey: "image1") as? String
                let saveDate: Date? = result.value(forKey: "saveDate") as? Date
                let content: String? = result.value(forKey: "content") as? String
                let startDate: Date? = result.value(forKey: "startDate") as? Date                
                let endDate: Date? = result.value(forKey: "endDate") as? Date
                
                print("title:\(title)","saveDate:\(saveDate)","image1:\(image1)","content:\(content)" ,"startDate:\(startDate)","endDate:\(endDate)")
//   ,":\()"    for copy

                diaryList.add(["title":title,"saveDate":saveDate,"image1":image1,"content":content,"startDate":startDate,"endDate":endDate])
//   ,"":
            }
        }catch{
        }
        
       myTableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        var dic = diaryList[indexPath.row] as! NSDictionary
        
        cell.textLabel?.text = dic["title"] as! String
        
        //文字を設定したセルを返す
        return cell
    }

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            
            
            // AppDelegateを使う用意をしておく
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            // エンティティを操作するためのオブジェクトを作成
            let viewContext = appDelegate.persistentContainer.viewContext
            
            // どのエンティティからdataを取得してくるか設定
            let request : NSFetchRequest<DIARY> = DIARY.fetchRequest()
            do {
                // 削除するデータを取得
                let fetchResults = try viewContext.fetch(request)
                for result: AnyObject in fetchResults {
                    let record = result as! NSManagedObject
                    // 一行ずつ削除
                    viewContext.delete(record)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    
                    diaryList.remove(at: indexPath.row)
                    myTableView.deleteRows(at: [indexPath], with: .fade)
                }
                // 削除した状態を保存
                try viewContext.save()
            
            } catch {
            }
        myTableView.reloadData()

        }
    
    }
    
    //セル削除
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
        
        dcSelectedDate = SaveDate[indexPath.row] as Date
        // AppDelegateを使う用意をしておく
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext
        
        // どのエンティティからdataを取得してくるか設定
        let request : NSFetchRequest<DIARY> = DIARY.fetchRequest()
        
        // 絞り込み検索(更新したいデータを取得する)
    let namePredicate =  NSPredicate(format: "saveDate = %@", dcSelectedDate as CVarArg)
                    request.predicate = namePredicate
        
    do {
    // 削除するデータを取得
    let fetchResults = try viewContext.fetch(request)
    for result: AnyObject in fetchResults {
    let record = result as! NSManagedObject
    // 一行ずつ削除
     viewContext.delete(record)
                        }
    // 削除した状態を保存
        try viewContext.save()
                    } catch {
            }
        read()
        }
    
    myTableView.reloadData()
                

    }

    //セルが選択されたとき発動
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("\(indexPath.row)行目が選択されました")
        
        //メンバ変数に行番号保存
        selectedIndex = indexPath.row
        
        //セグエを指定して画面遷移
        performSegue(withIdentifier: "hyouji", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "hyouji"{
        
        
        print("画面遷移直前:\(selectedIndex)行目選択")
        
        //次の遷移先の画面をインスタンス化して取得
        let secondVC = segue.destination as! showDiaryViewController
        
        //次の遷移先の画面のプロパティに、選択された行番号を保存
        secondVC.selectedNomber = selectedIndex
        
        }else{
    }
        
    }

    @IBAction func tapToAdd(_ sender: UIButton) {
        
        //画面遷移しなかったのでコードで
        performSegue(withIdentifier: "next", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
