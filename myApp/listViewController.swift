

import UIKit

class listViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTableView: UITableView!
    
     var diaryList = NSMutableArray()
    var selectedIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //文字を表示するセルの取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! customCell
        
        //表示文字の設定
        
        //        cell.textLabel?.text = teaList[indexPath.row]
        //        cell.textLabel?.textColor = UIColor.orange
        
        cell.titleLabel.text = teaList[indexPath.row]
        cell.messageLabel.text = messageList[indexPath.row]
        
        
        return cell
        
        
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
