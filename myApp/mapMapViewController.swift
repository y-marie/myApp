

import UIKit
import MapKit
import CoreData

class mapMapViewController: UIViewController, MKMapViewDelegate {
    
    var selectedName:String = ""
    var selectedIndex = -1
    
  @IBOutlet weak var map1: MKMapView!

    var diaryList = NSMutableArray()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let coordinate = CLLocationCoordinate2DMake(10.317347, 123.905759)
        
        let myPin = MKPointAnnotation()
        
        myPin.coordinate = coordinate
        myPin.coordinate = coordinate
        myPin.title = "ayala"
        map1.addAnnotation(myPin)
        
//        read ()
        
    }
    
//    func read(){
//        
//        //配列初期化
//        diaryList = NSMutableArray()
//        
//        //AppDelegateを使う準備をしておく
//        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
//        
//        //エンティティを操作するためのオブジェクトを作成
//        let viewContext = appDelegate.persistentContainer.viewContext
//        
//        //どのエンティティからdataを取得してくるか設定
//        let query: NSFetchRequest<DIARY> = DIARY.fetchRequest()
//        
//        do{
//            //データを一括取得
//            let fetchResults = try viewContext.fetch(query)
//            
//            //データの取得
//            for result: AnyObject in fetchResults{
//                
//                let firstImage: String? = result.value(forKey: "firstImage") as? String
//                
//                let saveDate: Date? = result.value(forKey: "saveDate") as? Date
//                
//                print("firstImage:\(firstImage) saveDate:\(saveDate)")
//                
//                diaryList.add(["firstImage":firstImage, "saveDate":saveDate])
//                
//            }
//        }catch{
//        }
//        
//    }
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        let reuseId = "pin"
        var pinView = map1.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
//            pinView?.animatesDrop = true
            let calloutButton = UIButton(type: .detailDisclosure)
            pinView!.rightCalloutAccessoryView = calloutButton
            pinView!.sizeToFit()
        }
        else {
            pinView?.annotation = annotation
        }
//        let rightButton: AnyObject! = UIButton(type: UIButtonType.detailDisclosure)
//        
//        pinView?.rightCalloutAccessoryView = rightButton as? UIView
        
        return pinView
    }

    
    private func mapView(mapView: MKMapView,annotationView View: MKAnnotation,calloutAccessoryControlTapped control:UIControl){
        print(#function)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            //print("button tapped")
            
            performSegue(withIdentifier: "showDiaryView", sender: nil)
        }
    }
    
    @IBAction func tapToShow(_ sender: UIButton) {
        
    }
    @IBAction func tapToShow2(_ sender: UIButton) {
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "taptap1" {
            selectedIndex = 0
        } else{
            selectedIndex = 1
        }
        
        //次の遷移先の画面をインスタンス化して取得
        let secondVC = segue.destination as! showDiaryViewController
        
        //次の遷移先の画面のプロパティに、選択された行番号を保存
        secondVC.selectedNomber = selectedIndex
    
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    
}
