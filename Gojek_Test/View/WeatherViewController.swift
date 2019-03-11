//
//  WeatherViewController.swift
//  Gojek_Test
//
//  Created by Ernando Kasaluhe on 09/03/19.
//  Copyright © 2019 Ernando. All rights reserved.
//

import UIKit
import MapKit

class WeatherViewController: UIViewController {

    var weather: Weather?
    var location: Location?
    var current: CurrentWeather?
    var forecast: ForecastWeather?
    var forecastDay = [Forecastday]()
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    @IBOutlet weak var labelCelcius: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let imageLoading: UIImageView = {
        let setupImage = UIImageView()
        setupImage.image = UIImage(named: "ic_loading.png")
        setupImage.translatesAutoresizingMaskIntoConstraints = false
        return setupImage
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLocationManager()
        setupLayoutContent()
        
    }
    
    func setupLocationManager() {
        locationManager.requestAlwaysAuthorization()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
        } else {
            print("Location services are not enabled")
        }
        
        var stringLat: Double = -6.175392
        var stringLon: Double = 106.827153
        
        stringLat = locationManager.location == nil ? stringLat : (locationManager.location?.coordinate.latitude)!
        stringLon = locationManager.location == nil ? stringLon : (locationManager.location?.coordinate.longitude)!
        
        requestWeather(withLat: "\(stringLat)", withLon: "\(stringLon)", andDays: 4)
    }
}

//MARK: - Setup Layout
extension WeatherViewController {
    func setupLayoutContent() {
        isHideContent(withIsHide: true, andLoadingHide: false)
        self.view.addSubview(imageLoading)
        addConstraintToImageLoading()
        setupImageLoading(imageView: imageLoading, aCircleTime: 1.0)
        setupTableView(withTableView: tableView)
    }
    
    func isHideContent(withIsHide isHide: Bool, andLoadingHide loadingHide: Bool) {
        imageLoading.isHidden = loadingHide
        UIView.animate(withDuration: 1.0, animations: {
            self.labelCelcius.isHidden = isHide
            self.labelLocation.isHidden = isHide
            self.tableView.isHidden = isHide
            self.setupTransitionTableView()
        })
    }
    
    func setupImageLoading(imageView: UIImageView, aCircleTime: Double) {
        UIView.animate(withDuration: aCircleTime/2, delay: 0.0, options: .curveLinear, animations: {
            imageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }, completion: { finished in
            UIView.animate(withDuration: aCircleTime/2, delay: 0.0, options: .curveLinear, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*2))
            }, completion: { finished in
                self.setupImageLoading(imageView: imageView, aCircleTime: aCircleTime)
            })
        })
    }
    
    func addConstraintToImageLoading() {
        imageLoading.widthAnchor.constraint(equalToConstant: 96).isActive = true
        imageLoading.heightAnchor.constraint(equalToConstant: 96).isActive = true
        imageLoading.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageLoading.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func setupTableView(withTableView tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        
        let shadowSize : CGFloat = 5.0
        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                   y: -shadowSize / 2,
                                                   width: self.view.frame.width,
                                                   height: 2.0))
        tableView.layer.masksToBounds = false
        tableView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        tableView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        tableView.layer.shadowOpacity = 0.5
        tableView.layer.shadowPath = shadowPath.cgPath
        
        tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "weatherCell")
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
    }
    
    func setupTransitionTableView() {
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.fillMode = CAMediaTimingFillMode.forwards
        transition.duration = 1.0
        transition.subtype = CATransitionSubtype.fromTop
        self.tableView.layer.add(transition, forKey: "UITableViewReloadDataAnimationKey")
        self.tableView.reloadData()
    }
}

//MARK: Request
extension WeatherViewController {
    func requestWeather(withLat lat: String, withLon lon: String, andDays days: Int) {
        Weather.getWeather(withQ: "\(lat),\(lon)", withDays: days) { result in
            
            switch result {
                
            case .success(let response):
                self.location = response.location
                self.current = response.current
                self.forecast = response.forecast
                self.forecastDay = (self.forecast?.forecastday)!
                self.setupContent(withC: (self.current?.tempC)!, andLocation: (self.location?.name)!)
                self.isHideContent(withIsHide: false, andLoadingHide: true)
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
                self.setupFailedView()
            }
        }
    }
}

//MARK: - Setup Content
extension WeatherViewController {
    func setupContent(withC c: Double, andLocation location: String) {
        setupLabelCelcius(withC: c)
        setupLabelLocation(withLocation: location)
    }
    
    func setupLabelCelcius(withC c: Double) {
        let newC = String(format: "%.0f", c)
        labelCelcius.text = newC + "°"
    }
    
    func setupLabelLocation(withLocation location: String) {
        labelLocation.text = location
    }
}

//MARK: - TableView
extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastDay.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherTableViewCell {
            
            let data = forecastDay[indexPath.row]
            cell.configureCell(withData: data)
            
            return cell
        } else {
            return WeatherTableViewCell()
        }
    }
}

// MARK: - Location Manager
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
}

//MARK - Action
extension WeatherViewController {
    func setupFailedView() {
        let vc = FailedViewController(nibName: "FailedViewController", bundle: nil)
        vc.delegate = self
        self.addChild(vc)
        vc.view.frame = self.view.frame
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
}

//MARK: - Failed Delegate
extension WeatherViewController: FailedDelegate {
    func setupRequestWeather() {
        var stringLat: Double = -6.175392
        var stringLon: Double = 106.827153
        
        stringLat = locationManager.location == nil ? stringLat : (locationManager.location?.coordinate.latitude)!
        stringLon = locationManager.location == nil ? stringLon : (locationManager.location?.coordinate.longitude)!
        
        requestWeather(withLat: "\(stringLat)", withLon: "\(stringLon)", andDays: 4)
    }
}
