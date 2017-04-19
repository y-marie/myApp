

import UIKit
import MapKit
import CoreData
import Photos
import Darwin

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
        
        read()
        
        
//        for diary in diaryList {
//            
//            var dic:NSDictionary = diary as! NSDictionary
//            
//            let latitude:NSString = dic["Latitude"] as! NSString
//            
//            let longitude:NSString = dic["Longitude"] as! NSString
//            
//            print(latitude)
//            print(longitude)
//            
////            let latitudef:Float = Float(dic["Latitude"])
//            
//            let latitudef:Float = latitude.floatValue
//            
//            let longitudef:Float = longitude.floatValue
//            
//            print(latitudef)
//            print(longitudef)
//            
//            //atof数字にする
//            
//            if latitudef != nil {
//                //let coordinate = CLLocationCoordinate2DMake(atof(latitude),atof(longitude))
//                let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(latitudef), CLLocationDegrees(longitudef))
//                let myPin = MKPointAnnotation()
//                
//                myPin.coordinate = coordinate
//                myPin.coordinate = coordinate
//                myPin.title = "ayala"
//                map1.addAnnotation(myPin)
//        }
//        }
//        
    }
    
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
            var i = 0
            
            for result: AnyObject in fetchResults{
                
                let image1: String? = result.value(forKey: "image1") as? String
                
                let saveDate: Date? = result.value(forKey: "saveDate") as? Date
                
                let title: String? = result.value(forKey: "title") as? String
                
                let startDate: Date? = result.value(forKey: "startDate") as? Date
                
                let endDate: Date? = result.value(forKey: "endDate") as? Date
                
                let content: String? = result.value(forKey:"content") as? String

                //imageから位置情報をとりだす
                
                
                let url = URL(string: image1 as String!)
                
                let fetchResult: PHFetchResult = PHAsset.fetchAssets(withALAssetURLs: [url!], options: nil)
                
                let asset = fetchResult.firstObject
                
                // コンテンツ編集セッションを開始するためのアセットの要求
                asset?.requestContentEditingInput(with: nil, completionHandler: { contentEditingInput, info in
                    
                    // contentEditingInput = 編集用のアセットに関する情報を提供するコンテナ
                    let url = contentEditingInput?.fullSizeImageURL
                    
                    // 対象アセットのURLからCIImageを生成
                    let inputImage = CIImage(contentsOf: url!)!
                    
                    if inputImage.properties["{GPS}"] != nil{
                    
                    let gps:NSDictionary = inputImage.properties["{GPS}"] as! NSDictionary
                    
                    print(gps)
                
                    
                    let latitude:String! = String(describing: gps["Latitude"]!)
                
                    let longitude:String! = String(describing: gps["Longitude"]!)
                
       
                    
        print("image1:\(image1) saveDate:\(saveDate) title:\(title) latitude\(latitude) longitude:\(longitude)","content:\(content)","startDate:\(startDate)","ednDate:\(endDate)")
                    
        
                    self.diaryList.add(["image1":image1, "saveDate":saveDate,"title":title,"longitude":longitude,"latitude":latitude,"startDate":startDate,"content":content,"endDate":endDate])
                    
                    
                    print(latitude)
                    print(longitude)
                    
                    //            let latitudef:Float = Float(dic["Latitude"])
                    
                    let latitudef:Double = atof(latitude)
                    
                    let longitudef:Double = atof(longitude)
                    
//                    print(latitudef)
                    print(longitudef)
                    
                    //atof数字にする
                    
                    if latitudef != nil {
                        //let coordinate = CLLocationCoordinate2DMake(atof(latitude),atof(longitude))
                        
                        let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(latitudef), CLLocationDegrees(longitudef))
                        
                        let myPin = MKPointAnnotation()
                        
                        myPin.coordinate = coordinate
                        myPin.coordinate = coordinate
                        myPin.title = "ayala"
                        myPin.setValue(i, forKey: "tag")
                        
                        self.map1.addAnnotation(myPin)
                    
                        
                  i = i + 1
                        
                        }
                }
                    
                    })
                
            }
        }catch{
        }
        
    }
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
                print(pinView?.value(forKey: "tag"))
            
            let calloutButton = UIButton(type: .detailDisclosure)
            pinView!.rightCalloutAccessoryView = calloutButton
            pinView!.sizeToFit()
        }
        else {
            pinView?.annotation = annotation
        }
//        let rightButton: AnyObject! = UIButton(type:)
//        
//        pinView?.rightCalloutAccessoryView = rightButton as? UIView
        
        return pinView
        
    }

    
    private func mapView(mapView: MKMapView,annotationView View: MKAnnotation,calloutAccessoryControlTapped control:UIControl){
        print(#function)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            print("button tapped")
            
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
