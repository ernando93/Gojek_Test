//
//  WeatherTableViewCell.swift
//  Gojek_Test
//
//  Created by Ernando Kasaluhe on 09/03/19.
//  Copyright © 2019 Ernando. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var labelDay: UILabel!
    @IBOutlet weak var labelC: UILabel!
    
    func configureCell(withData data: Forecastday) {
        setupContent(withDate: data.date, andC: data.day?.avgTempC ?? 0)
    }
}

//MARK: - Setup Content
extension WeatherTableViewCell {
    func setupContent(withDate date: String, andC c: Double) {
        setupLabelDay(withDate: date)
        setupLabelC(withC: c)
    }
    
    func setupLabelDay(withDate date: String) {
        let day = Constant.getDayNameBy(stringDate: date)
        labelDay.text = day
    }
    
    func setupLabelC(withC c: Double) {
        let newC = String(format: "%.0f", c)
        labelC.text = newC + " C"
    }
}
