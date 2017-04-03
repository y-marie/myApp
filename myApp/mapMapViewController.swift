

import UIKit
import MapKit

class mapMapViewController: UIViewController, MKMapViewDelegate {
    
  @IBOutlet weak var map1: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let coordinate = CLLocationCoordinate2DMake(10.317347, 123.905759)
        
        let myPin = MKPointAnnotation()
        
        myPin.coordinate = coordinate
        
        myPin.coordinate = coordinate
        
        myPin.title = "ayala"
        
        map1.addAnnotation(myPin)
        
//        let reuseId = "pin"
//        
//        var pinView = map1.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
//        
//        pinView?.canShowCallout = true
//        
//        let rightButton: AnyObject! = UIButton(type: UIButtonType.detailDisclosure)
//        pinView?.rightCalloutAccessoryView = rightButton as? UIView

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

    
//    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        print(#function)
//    }
    
    private func mapView(mapView: MKMapView,annotationView View: MKAnnotation,calloutAccessoryControlTapped control:UIControl){
        print(#function)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            //print("button tapped")
            
            performSegue(withIdentifier: "showDiaryView", sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    
}
