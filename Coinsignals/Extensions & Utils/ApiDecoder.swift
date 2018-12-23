//
//  ApiDecoder.swift
//  Coinsignals
//
//  Created by Julian Praest on 12/23/18.
//  Copyright © 2018 Org. All rights reserved.
//

import Foundation

class ApiDecoder: JSONDecoder {
    override init() {
        super.init()
        let dF = DateFormatter()
        dF.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateDecodingStrategy = .formatted(dF)
    }
}
