

import UIKit

class memoViewController: UIViewController {

    @IBOutlet weak var myMemoField: UITextView!
    
    var memoMemo = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         var myDefault = UserDefaults.standard
        
        if (myDefault.object(forKey:"memoMemo") != nil){
           
            
            myMemoField.text = myDefault.object(forKey:"memoMemo") as! String
        }
        print(memoMemo)
    }

    @IBAction func tapToSaveMemo(_ sender: UIButton) {
        
        memoMemo.add(["memo":myMemoField])
        
        print(memoMemo)
        
        var myDefault = UserDefaults.standard
      
        //配列を丸ごとUserDefaultに書き込み
        myDefault.set(myMemoField.text,forKey:"memoMemo")
        
        myDefault.synchronize()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func tapToDelete(_ sender: UIButton) {
    }
}
