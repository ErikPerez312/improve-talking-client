//
//  String+Extensions.swift
//  improve-talking
//
//  Created by Erik Perez on 10/12/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import Foundation

extension String {
    var isEmptyOrWhitespace: Bool {
        return self.trimmingCharacters(in: CharacterSet.whitespaces) == ""
    }
}
