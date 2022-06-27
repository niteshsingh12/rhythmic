//
//  AlertView.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 27/06/22.
//

import Foundation
import UIKit

struct Alert {
    
    static func present(title: String?, message: String, actions: Alert.Action?..., from controller: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alertController.addAction(action!.alertAction)
        }
        controller.present(alertController, animated: true, completion: nil)
    }
}

extension Alert {
    
    enum Action {
        
        case retry(handler: (() -> Void)?)
        case okay
        
        private var title: String {
            switch self {
            case .retry:
                return "Retry"
            case .okay:
                return "Okay"
            }
        }
        
        private var handler: (() -> Void)? {
            switch self {
            case .retry(let handler):
                return handler
            case .okay:
                return nil
            }
        }
        
        var alertAction: UIAlertAction {
            return UIAlertAction(title: title, style: .default, handler: { _ in
                if let handler = self.handler {
                    handler()
                }
            })
        }
    }
}
