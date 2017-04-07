

import UIKit

class memoViewController: UIViewController {

    @IBOutlet weak var myMemoField: UITextView!
    
    var memoMemo = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         var myDefault = UserDefaults.standard
    
//        if (myDefault.object(forKey:"memoMemo") != nil){
//            memoMemo = NSMutableArray(array: myDefault.object(forKey:"memoMemo") as! NSMutableArray)
//        }
//        
//        var dic = memoMemo as! NSDictionary
//        
//        myMemoField?.text = dic["title"] as! String
//

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func tapToDelete(_ sender: UIButton) {
    }
}
