import UIKit

import MapKit

import CoreLocation

class MapViewController: UIViewController {
    
    var myLocationManager :CLLocationManager!
    
    @IBOutlet weak var mainMapView: MKMapView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.myLocationManager = CLLocationManager()
        
        self.myLocationManager.delegate = self
        
        self.myLocationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        
        self.myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.mainMapView.mapType = .standard

        self.mainMapView.showsUserLocation = true
        
        self.mainMapView.isZoomEnabled = true
        
        let latDelta = 0.05
        
        let longDelta = 0.05
        
        let currentLocationSpan:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        
        let center:CLLocation = CLLocation(latitude: 25.05, longitude: 121.515)
        
        let currentRegion:MKCoordinateRegion = MKCoordinateRegion(center:center.coordinate,
        span: currentLocationSpan)
        
        self.mainMapView.setRegion(currentRegion, animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            
            self.myLocationManager.requestWhenInUseAuthorization()
            
            self.myLocationManager.startUpdatingLocation()
            
        }
        
        else if CLLocationManager.authorizationStatus() == .denied {
    
            let alertController = UIAlertController(title: "定位權限已關閉",message:"如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟",preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "確認", style: .default, handler:nil)
            
            alertController.addAction(okAction)
            
            self.present(alertController,animated: true, completion: nil)
            
        }
        
        else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            self.myLocationManager.startUpdatingLocation()
            
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        self.myLocationManager.stopUpdatingLocation()
        
    }

}

extension MapViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let currentLocation : CLLocation = locations[0] as CLLocation
        
        print("\(currentLocation.coordinate.latitude)")
        
        print(", \(currentLocation.coordinate.longitude)")
        
    }
    
}
