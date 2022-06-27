//
//  HomeViewController.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 20/06/22.
//

import Foundation
import UIKit
import Combine

final class HomeViewController: UIViewController {
        
    // MARK: - Properties
    
    typealias Datasource = UICollectionViewDiffableDataSource<HomeViewModel.Section, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<HomeViewModel.Section, AnyHashable>
    
    var datasource: Datasource!
    var cancellableSet = Set<AnyCancellable>()
    
    var contentView: HomeListView
    var homeViewModel: HomeViewModel
    var imageRepository: ImageRepository
    weak var coordinator: HomeBaseCoordinator?
    var playingIndexPath = IndexPath()
    var miniPlayer: MiniPlayerViewController?
    
    // MARK: - Initializer
    
    init(contentView: HomeListView, viewModel: HomeViewModel, imageRepository: ImageRepository) {
        self.contentView = contentView
        self.homeViewModel = viewModel
        self.imageRepository = imageRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupCollectionView()
        setupDatasource()
        fetchTopCharts()
        self.title = "Home"
    }
    
    // MARK: - Methods
    
    func showMiniMusicPlayerFor(track: Track) {
        miniPlayer = self.addMiniPlayerToWindow()
        
        self.view.backgroundColor = .systemBackground
        self.contentView.listCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: miniPlayerHeight, right: 0)
    }
    
    private func fetchTopCharts() {
        homeViewModel.fetchChart()
    }
    
    private func setupBindings() {
        homeViewModel.$chart
            .receive(on: RunLoop.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] chart in
                self?.updateSections(result: chart!)
            })
            .store(in: &cancellableSet)
        
        homeViewModel.$state
            .receive(on: RunLoop.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] state in
                switch state {
                case .error(let error):
                    self?.showAlertForError(error: error)
                default: ()
                }
            })
            .store(in: &cancellableSet)
    }
    
    // MARK: - Snapshot Methods
    
    func updateSections(result: Chart) {
        let snapshot = snapshotForCurrentState(chart: result)
        datasource.apply(snapshot, animatingDifferences: true)
    }
    
    ///Prepare snapshot with sections and respective items, and fetch static images for displaying on collection cells
    func snapshotForCurrentState(chart: Chart) -> Snapshot {
        
        var snapshot = Snapshot()
        
        let topTracks = chart.tracks.data
        if !topTracks.isEmpty {
            snapshot.appendSections([.tracks])
            snapshot.appendItems(topTracks, toSection: .tracks)
        }
        
        let topArtists = chart.artists.data
        if !topArtists.isEmpty {
            snapshot.appendSections([.artists])
            snapshot.appendItems(topArtists, toSection: .artists)
        }
        
        let topAlbums = chart.albums.data
        if !topAlbums.isEmpty {
            snapshot.appendSections([.albums])
            snapshot.appendItems(topAlbums, toSection: .albums)
        }
        
        let topPlaylists = chart.playlists.data
        if !topPlaylists.isEmpty {
            snapshot.appendSections([.playlists])
            snapshot.appendItems(topPlaylists, toSection: .playlists)
        }
        
        let topPodcasts = chart.podcasts.data
        if !topPodcasts.isEmpty {
            snapshot.appendSections([.podcasts])
            snapshot.appendItems(topPodcasts, toSection: .podcasts)
        }
        
        return snapshot
    }
    
    // MARK: - Alert Methods
    
    func showAlertForError(error: Error) {
        Alert.present(title: "Information",message: error.localizedDescription, actions: .retry(handler: {
            self.fetchTopCharts()
        }), .okay, from: self)
    }
}
