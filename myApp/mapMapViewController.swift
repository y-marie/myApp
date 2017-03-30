import UIKit
import MapKit

class mapMapViewController: UIViewController {
    
  @IBOutlet weak var map1: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let coordinate = CLLocationCoordinate2DMake(10.317347, 123.905759)
        
        let myPin = MKPointAnnotation()
        
        myPin.coordinate = coordinate
        
        myPin.coordinate = coordinate
        
        myPin.title = "ayala"
        
        map1.addAnnotation(myPin)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    
}
