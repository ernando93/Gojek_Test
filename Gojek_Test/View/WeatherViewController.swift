//
//  WeatherViewController.swift
//  Gojek_Test
//
//  Created by Ernando Kasaluhe on 09/03/19.
//  Copyright © 2019 PT Kita Indonesia Plus. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

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

        imageLoading.isHidden = true
        setupLayoutContent()
        
    }

}

//MARK: - Layout
extension WeatherViewController {
    func setupLayoutContent() {
        self.view.addSubview(imageLoading)
        addConstraintToImageLoading()
        setupImageLoading(imageView: imageLoading, aCircleTime: 1.0)
    }
    
    func setupImageLoading(imageView: UIImageView, aCircleTime: Double) { //UIView
        
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
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
}


//MARK: - TableView
extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
