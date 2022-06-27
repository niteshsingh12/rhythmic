//
//  ChartCoordinator.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 20/06/22.
//

import Foundation
import UIKit

final class HomeCoordinator: HomeBaseCoordinator {
    
    // MARK: - Properties
    
    var parentCoordinator: AppBaseCoordinator?
    lazy var rootViewController: UIViewController = UIViewController()
    lazy var childCoordinators: [Coordinator] = []
    
    // MARK: - Methods
    
    func start() -> UIViewController {
        let chartsViewController = HomeViewController(contentView: setupContentView(), viewModel: setupViewModelDependencies(), imageRepository: DefaultImageRepository())
        chartsViewController.coordinator = self
        
        rootViewController = UINavigationController(rootViewController: chartsViewController)
        return rootViewController
    }
    
    func moveToTrackListWith(artist: Artist) {
        let detailViewController = ArtistTracksViewController(artist: artist, contentView: setupDetailContentView(), viewModel: setupDetailViewModelDependencies(), imageRepository: DefaultImageRepository())
        navigationRootViewController?.pushViewController(detailViewController, animated: true)
        detailViewController.coordinator = self
        hideNavigationBar()
    }
    
    func moveToAlbumDetailWith(album: Album) {
        let detailViewController = AlbumTracksViewController(album: album, contentView: setupDetailContentView(), viewModel: setupDetailViewModelDependencies(), imageRepository: DefaultImageRepository())
        navigationRootViewController?.pushViewController(detailViewController, animated: true)
        detailViewController.coordinator = self
        hideNavigationBar()
    }
    
    func moveToPlaylistDetailWith(playlist: Playlist) {
        let detailViewController = PlaylistTracksViewController(playlist: playlist, contentView: setupDetailContentView(), viewModel: setupDetailViewModelDependencies(), imageRepository: DefaultImageRepository())
        navigationRootViewController?.pushViewController(detailViewController, animated: true)
        detailViewController.coordinator = self
        hideNavigationBar()
    }
    
    func moveBackToHomePage() {
        navigationRootViewController?.popViewController(animated: true)
        navigationRootViewController?.navigationBar.isHidden = false
    }
    
    // MARK: - Charts Dependencies
    
    private func setupContentView() -> HomeListView {
        return HomeListView()
    }
    
    private func setupViewModelDependencies() -> HomeViewModel {
        let chartsService = setupServiceDependency()
        let viewModel = HomeViewModel(service: chartsService)
        return viewModel
    }
    
    private func setupServiceDependency() -> DefaultChartRepository {
        let networkEngine = DefaultNetworkService()
        return DefaultChartRepository(service: networkEngine)
    }
    
    // MARK: - Tracks Dependencies
    
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
    
    func didFinish(_ child: Coordinator) {
        removeChild(child)
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
}
