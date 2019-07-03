import UIKit

import MapKit

import CoreLocation

protocol UIMapViewControllerDelegate : class {
    
    func upDateMapTxt(textField:UITextField)
    
}

class MapViewController: UIViewController {
    
    weak var delegate : UIMapViewControllerDelegate?
    
    var currentLocation = CLLocation()
    
    var myLocationManager :CLLocationManager!

    @IBOutlet weak var mainMapView: MKMapView!

    @IBOutlet weak var MapAddressTxt: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.myLocationManager = CLLocationManager()
        
        self.myLocationManager.delegate = self
        
        self.myLocationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        
        self.myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.mainMapView.mapType = .standard

        self.mainMapView.showsUserLocation = true
        
        self.mainMapView.isZoomEnabled = true
        
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
    
    func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
        
        let locale = Locale(identifier: "zh_TW")
        
        let loc: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        if #available(iOS 11.0, *) {
            
            CLGeocoder().reverseGeocodeLocation(loc, preferredLocale: locale) { placemarks, error in
                
                guard let placemark = placemarks?.first, error == nil else {
                    
                    UserDefaults.standard.removeObject(forKey: "AppleLanguages")
                    
                    completion(nil, error)
                    
                    return
                    
                }
                
                completion(placemark, nil)
                
            }
            
        }
        
    }
    
    func locationAddress() {
        
        //CLGeocoder地理編碼 經緯度轉換地址位置
        geocode(latitude: self.currentLocation.coordinate.latitude, longitude:self.currentLocation.coordinate.longitude ) { placemark, error in
            
            guard let placemark = placemark, error == nil else { return }
            // you should always update your UI in the main thread
            DispatchQueue.main.async {
                //  update UI here
                print("address1:", placemark.thoroughfare ?? "")
                
                print("address2:", placemark.subThoroughfare ?? "")
                
                print("city:",     placemark.locality ?? "")
                
                print("state:",    placemark.subAdministrativeArea ?? "")
                
                print("zip code:", placemark.postalCode ?? "")
                
                print("country:",  placemark.country ?? "")
                
                print("placemark",placemark)
                
                self.MapAddressTxt.text = "\(placemark.country!)\(placemark.subAdministrativeArea!)\(placemark.locality!)\(placemark.thoroughfare!)\(placemark.subThoroughfare!)號"
                
            }
            
        }
        
    }
    
    @IBAction func done(_ sender: Any) {
        
        self.delegate?.upDateMapTxt(textField: self.MapAddressTxt)
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
}

extension MapViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.currentLocation = locations[0]
        
        let currentLocationSpan:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        let currentRegion  = MKCoordinateRegion(center:self.currentLocation.coordinate, span: currentLocationSpan)
        
        self.mainMapView.setRegion(currentRegion, animated: true)
        
        print("\(self.currentLocation.coordinate.latitude)")
        
        print(",\(self.currentLocation.coordinate.longitude)")
        
        self.locationAddress()
        
    }
    
}
