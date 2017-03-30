import UIKit
import MapKit

class mapToSelectViewController: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var myMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coordinate = CLLocationCoordinate2DMake(10.317347, 123.905759)
        
        let myPin = MKPointAnnotation()
        
            myPin.coordinate = coordinate
        
        myPin.coordinate = coordinate
        
        myPin.title = "ayala"
        
        myMap.addAnnotation(myPin)
        
        let pinView = myMap.dequeueReusableAnnotationView as? MKPinAnnotationView
        
        pinView?.canShowCallout = true
        
        let rightButton: AnyObject! = UIButton(type: UIButtonType.detailDisclosure)
        pinView?.rightCalloutAccessoryView = rightButton as? UIView
        
        
        func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            print(#function)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    
}
