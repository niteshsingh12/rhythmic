//
//  SearchBaseController.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 23/06/22.
//

import Foundation

protocol SearchBaseCoordinator: Coordinator {
    func moveToTrackListWith(artist: Artist)
    func moveBackToSearchPage()
}
