//
//  SearchCoordinator.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 23/06/22.
//

import Foundation
import UIKit

class SearchCoordinator: SearchBaseCoordinator {
    
    // MARK: - Properties
    
    var parentCoordinator: AppBaseCoordinator?
    lazy var rootViewController: UIViewController = UIViewController()
    lazy var childCoordinators: [Coordinator] = []
    
    // MARK: - Methods
    
    func start() -> UIViewController {
        
        let searchViewController = ArtistSearchViewController(contentView: setupContentView(), viewModel: setupViewModelDependencies(), imageRepository: DefaultImageRepository())
        searchViewController.coordinator = self
        
        rootViewController = UINavigationController(rootViewController: searchViewController)
        return rootViewController
    }
    
    func moveToTrackListWith(artist: Artist) {
        
        let detailViewController = ArtistTracksViewController(artist: artist, contentView: setupDetailContentView(), viewModel: setupDetailViewModelDependencies(), imageRepository: DefaultImageRepository())
        navigationRootViewController?.pushViewController(detailViewController, animated: true)
        detailViewController.coordinator = self
        hideNavigationBar()
    }
    
    func moveBackToSearchPage() {
        navigationRootViewController?.popViewController(animated: true)
        navigationRootViewController?.navigationBar.isHidden = false
    }
    
    // MARK: - Dependencies
    
    private func setupContentView() -> SearchResultsView {
        return SearchResultsView()
    }
    
    private func setupViewModelDependencies() -> ArtistSearchViewModel {
        let searchService = setupServiceDependency()
        let viewModel = ArtistSearchViewModel(service: searchService)
        return viewModel
    }
    
    private func setupServiceDependency() -> DefaultSearchArtistsRepository {
        let networkEngine = DefaultNetworkService()
        return DefaultSearchArtistsRepository(service: networkEngine)
    }
    
    private func setupDetailContentView() -> TracksDetailView {
        return TracksDetailView()
    }
    
    private func setupDetailViewModelDependencies() -> TrackViewModel {
        let detailService = setupDetailServiceDependency()
        let viewModel = TrackViewModel(service: detailService)
        return viewModel
    }
    
    private func setupDetailServiceDependency() -> DefaultTracksRepository {
        let networkEngine = DefaultNetworkService()
        return DefaultTracksRepository(service: networkEngine)
    }
    
    // MARK: - Navigation Appearance
    
    private func configureNavigation() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue]
        appearance.shadowColor = .clear

        let navigationBar = navigationRootViewController!.navigationBar
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.isTranslucent = false
        navigationBar.isHidden = false
    }
    
    private func hideNavigationBar() {
        let navigationBar = navigationRootViewController!.navigationBar
        navigationBar.isHidden = true
    }
    
    func didFinish(_ child: Coordinator) {}
}
