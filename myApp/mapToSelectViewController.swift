

import UIKit
import MapKit

class mapToSelectViewController: UIViewController {

    @IBOutlet weak var myMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coordinate = CLLocationCoordinate2DMake(10.317347, 123.905759)
        
        let myPin = MKPointAnnotation()
        
            myPin.coordinate = coordinate
        
        myPin.coordinate = coordinate
        
        myPin.title = "ayala"
        
        myMap.addAnnotation(myPin)
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    
}
