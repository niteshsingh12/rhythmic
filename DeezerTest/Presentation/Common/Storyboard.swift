//
//  Storyboard.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 27/06/22.
//

import UIKit

enum Storyboard: String {
    
    case Main
    var storyboard : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
}
