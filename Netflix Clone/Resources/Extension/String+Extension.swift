//
//  String+Extension.swift
//  Netflix Clone
//
//  Created by Burak AKCAN on 11.09.2022.
//

import Foundation

extension String {
    func capitalizedfirstLetter()->String{
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
