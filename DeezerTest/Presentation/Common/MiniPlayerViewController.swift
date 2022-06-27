//
//  MiniPlayerViewController.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 27/06/22.
//

import UIKit

var miniPlayerHeight = 70.0

extension UIViewController {
    
    func addMiniPlayerToWindow() -> MiniPlayerViewController {
        
        let controller = Storyboard.Main.storyboard.instantiateViewController(withIdentifier: "MiniVC") as! MiniPlayerViewController
        
        controller.trackViewModel = TrackViewModel(service: DefaultTracksRepository(service: DefaultNetworkService()))
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!
        window.rootViewController?.view.addSubview(controller.view)
        window.rootViewController?.addChild(controller)
        
        controller.didMove(toParent: window.rootViewController)
        controller.view.frame = CGRect(x: 0, y: tabBarController!.tabBar.frame.origin.y - miniPlayerHeight, width: self.view.frame.width, height: miniPlayerHeight)
        controller.view.backgroundColor = .clear
        isMiniPlayerVisible = true
        return controller
    }
}
