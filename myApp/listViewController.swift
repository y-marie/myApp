

import UIKit
import CoreData

class listViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTableView: UITableView!
    
     var diaryList = NSMutableArray()
    
    var selectedIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        read()
//        
//        let dic = diaryList[selectedIndex] as! NSDictionary
//        
//        print(dic)
        
        //cell.textLabel?.text = dic["title"] as! String
    }
    
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
                
                print("title:\(title)")
                
                diaryList.add(["title":title])
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

    
    //セルが選択されたとき発動
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("\(indexPath.row)行目が選択されました")
        
        //メンバ変数に行番号を保存
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
        secondVC.scSelectedIndex = selectedIndex
        
        }else{
            
//            let storyboard: UIStoryboard = self.storyboard!
//            
//            let nextView = storyboard.instantiateViewController(withIdentifier: "next") as! writeDiaryViewController
//            
//            self.present(nextView, animated: true,completion: nil)
            
        }
        
    }

    @IBAction func tapToAdd(_ sender: UIButton) {
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
