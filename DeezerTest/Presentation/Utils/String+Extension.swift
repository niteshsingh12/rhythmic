//
//  String+Extension.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 27/06/22.
//

import Foundation

///String convenience method for localization
extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
