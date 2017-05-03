

import UIKit
import MapKit
import CoreData
import Photos
import Darwin
import CoreLocation
import GoogleMobileAds

class mapMapViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate,GADBannerViewDelegate {
    
    var selectedName:String = ""
    var selectedIndex = -1
    
  @IBOutlet weak var map1: MKMapView!

    var diaryList = NSMutableArray()
    var locationManager: CLLocationManager!
    
    // AdMob ID を入れてください
    let AdMobID = "ca-app-pub-3530000000000000/0123456789"
    let TEST_DEVICE_ID = "61b0154xxxxxxxxxxxxxxxxxxxxxxxe0"    //ID系はgitにpushする際載せないようにメモとかしておく。
    
    let AdMobTest:Bool = true
    let SimulatorTest:Bool = false
    
    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        switch status {
//        case .notDetermined:
//            locationManager.requestWhenInUseAuthorization()
//        case .restricted, .denied:
//            break
//        case .authorizedAlways, .authorizedWhenInUse:
//            break
//        }
//    }
    
    
    //中心地一度だけ現在地にする(フラグ)
    var regionout:Bool = false
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if regionout == false {
        switch status {
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        
            }
            regionout = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.map1.delegate = self
        
         map1.showsUserLocation = true
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager = CLLocationManager()
            self.locationManager.delegate = self
            self.locationManager.startUpdatingLocation()
        }
        
        //map1.userTrackingMode = MKUserTrackingMode.follow
    
        //広告を表示する関数を呼び出す
        showAdBanner()
    }
    
    //広告を表示する
    func showAdBanner(){
        
        var admobView = GADBannerView()
        admobView = GADBannerView(adSize:kGADAdSizeBanner)
        admobView.frame.origin = CGPoint(x:0, y:self.view.frame.size.height - admobView.frame.height - 60)
        
        admobView.frame.size = CGSize(width:self.view.frame.width, height:admobView.frame.height)
        admobView.adUnitID = AdMobID
        admobView.delegate = self
        admobView.rootViewController = self
        
        let admobRequest = GADRequest()
        
        if(AdMobTest){
            // simulator テスト
            if SimulatorTest {
                admobRequest.testDevices = [kGADSimulatorID]
                print("simulator")
            }
                // 実機テスト
            else {
                admobRequest.testDevices = [TEST_DEVICE_ID]
                print("device")
            }
        }
            // 本番
            admobView.load(admobRequest)
        
        self.view.addSubview(admobView)
        
    }
    
      override func viewWillAppear(_ animated: Bool) {
        
        read()

    }
    
    // 位置情報が更新されるたびに呼ばれる
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        map1.setCenter((locations.last?.coordinate)!, animated: true)
        
        guard let newLocation = locations.last else {
            return
        }
        
    }
    
    func read(){
        
        //配列初期化
        diaryList = NSMutableArray()
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let query: NSFetchRequest<DIARY> = DIARY.fetchRequest()
        
        do{
            
            let fetchResults = try viewContext.fetch(query)
           
            var i = 0
            
            for result: AnyObject in fetchResults{
                
                let image1: String? = result.value(forKey: "image1") as? String
                let saveDate: Date? = result.value(forKey: "saveDate") as? Date
                let title: String? = result.value(forKey: "title") as? String
                let startDate: Date? = result.value(forKey: "startDate") as? Date
                let endDate: Date? = result.value(forKey: "endDate") as? Date
                let content: String? = result.value(forKey:"content") as? String

                //imageから位置情報をとりだす
                
                if image1 != nil{
                    
                let url = URL(string: image1 as String!)
                
                let fetchResult: PHFetchResult = PHAsset.fetchAssets(withALAssetURLs: [url!], options: nil)
                
                let asset = fetchResult.firstObject
                
                // コンテンツ編集セッションを開始するためのアセットの要求
                asset?.requestContentEditingInput(with: nil, completionHandler: { contentEditingInput, info in
                    
                    // contentEditingInput = 編集用のアセットに関する情報を提供するコンテナ
                    let url = contentEditingInput?.fullSizeImageURL
                    
                    // 対象アセットのURLからCIImageを生成
                    let inputImage = CIImage(contentsOf: url!)!
                    
                    print( inputImage.properties);
                    
                    if inputImage.properties["{GPS}"] != nil{
                    
                    let gps:NSDictionary = inputImage.properties["{GPS}"] as! NSDictionary
                    
                    print(gps)
                
                    
                    let latitude:String! = String(describing: gps["Latitude"]!)
                
                    let longitude:String! = String(describing: gps["Longitude"]!)
                
       
                    
        print("image1:\(image1) saveDate:\(saveDate) title:\(title) latitude\(latitude) longitude:\(longitude)","content:\(content)","startDate:\(startDate)","ednDate:\(endDate)")
                    
        
        self.diaryList.add(["image1":image1, "saveDate":saveDate,"title":title,"longitude":longitude,"latitude":latitude,"startDate":startDate,"content":content,"endDate":endDate])
                    
                    
                    print(latitude)
                    print(longitude)

                    let latitudef:Double = atof(latitude)
                    
                    let longitudef:Double = atof(longitude)
                    
                    print(latitudef)
                    print(longitudef)
                    
                    //atof数字にする
                    
                    if latitudef != nil {
                        //let coordinate = CLLocationCoordinate2DMake(atof(latitude),atof(longitude))
                        
                        let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(latitudef), CLLocationDegrees(longitudef))
                        
                        let myPin = CustomAnnotation()
                        
                        myPin.coordinate = coordinate
                        myPin.coordinate = coordinate
                        myPin.title = "\(title!)"
                        //optional消す
                        myPin.tag = i
                
                        self.map1.addAnnotation(myPin)
                       
                  i = i + 1
                        
                        }
                }
                    
                }) }
                
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
                
             let custompin = annotation as! CustomAnnotation
                
                calloutButton.tag  = custompin.tag
                
                
            pinView!.rightCalloutAccessoryView = calloutButton
            pinView!.sizeToFit()
        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView
        
    }

    
    private func mapView(mapView: MKMapView,annotationView View: MKAnnotation,calloutAccessoryControlTapped control:UIControl){
        print(#function)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            
            print("button tapped")
        
            var tag = (control as! UIButton).tag
            
            print(tag)
            
            selectedIndex = tag
            
            performSegue(withIdentifier: "showDiaryView", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var dic = diaryList[selectedIndex] as! NSDictionary
        
        //次の遷移先の画面をインスタンス化して取得
        let secondVC = segue.destination as! showDiaryViewController
        
        //次の遷移先の画面のプロパティに、セーブデータを送る
        secondVC.selectedSaveDate = dic["saveDate"] as! Date
    
    }
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
