//
//  Constant.swift
//  Gojek_Test
//
//  Created by Ernando Kasaluhe on 09/03/19.
//  Copyright © 2019 Ernando. All rights reserved.
//

import Foundation

let kAPIURL = Environment().configuration(PlistKey.ApiURL)

class Constant: NSObject {
    
    static func getDayNameBy(stringDate: String) -> String {
        let df  = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let date = df.date(from: stringDate)!
        df.dateFormat = "EEEE"
        return df.string(from: date);
    }
}
