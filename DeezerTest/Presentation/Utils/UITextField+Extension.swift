//
//  UITextField+Extension.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 23/06/22.
//

import Foundation
import Combine
import UIKit

extension UITextField {
    
    ///This variable creates a publisher instance to textfield and returns it for subscriber to subscribe
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField } ///receiving notifications with objects which are instances of UITextFields
            .compactMap(\.text) ///extracting text and removing optional values (even though the text cannot be nil)
            .eraseToAnyPublisher()
    }
}
