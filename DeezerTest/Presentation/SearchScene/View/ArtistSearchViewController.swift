//
//  ArtistSearchViewController.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 23/06/22.
//

import Foundation
import UIKit
import Combine

final class ArtistSearchViewController: UIViewController {
        
    // MARK: - Properties
    
    typealias Datasource = UICollectionViewDiffableDataSource<ArtistSearchViewModel.Section, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<ArtistSearchViewModel.Section, AnyHashable>
    
    var datasource: Datasource!
    var currentSnapshot: Snapshot?
    var cancellableSet = Set<AnyCancellable>()
    
    var contentView: SearchResultsView
    var searchViewModel: ArtistSearchViewModel
    var imageRepository: ImageRepository
    weak var coordinator: SearchBaseCoordinator?

    // MARK: - Initializer
    
    init(contentView: SearchResultsView, viewModel: ArtistSearchViewModel, imageRepository: ImageRepository) {
        self.contentView = contentView
        self.searchViewModel = viewModel
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
        setupDatasource()
        setupCollectionView()
        prepareNavigationItems()
        addContentViewInsetIfMiniPlayerIsOn()
    }
    
    func addContentViewInsetIfMiniPlayerIsOn() {
        if isMiniPlayerVisible {
            self.view.backgroundColor = .systemBackground
            self.contentView.listCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: miniPlayerHeight, right: 0)
        }
    }
    
    func prepareNavigationItems() {
        navigationItem.titleView = contentView.searchBar
    }
    
    // MARK: - Binder Methods
    
    private func setupBindings() {
        bindViewToViewModel()
        bindViewModelToView()
    }
    
    private func bindViewModelToView() {
        
        searchViewModel.$artists
            .receive(on: RunLoop.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] artists in
                self?.updateSearchResults(artists: artists)
            })
            .store(in: &cancellableSet)
        
        searchViewModel.$state
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
    
    ///Binds view to view model, listens to changes in searchbar text, fetches api if changed
    private func bindViewToViewModel() {
        
        contentView.searchBar.searchTextField.textPublisher
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak searchViewModel] in
                if !$0.isEmpty {
                    let request = ArtistSearch(query: $0)
                    searchViewModel?.searchArtists(request: request)
                }
            }
            .store(in: &cancellableSet)
    }
    
    // MARK: - Snapshot
    
    ///Creates a snapshot with section and items and applies, if datasource is changed, view will reload
    func updateSearchResults(artists: [Artist]) {
        
        currentSnapshot = snapshotForSearchState(artists: artists)
        datasource.apply(currentSnapshot!, animatingDifferences: true)
    }
    
    func snapshotForSearchState(artists: [Artist]) -> Snapshot {
        
        var snapshot = Snapshot()
        
        if !artists.isEmpty {
            
            snapshot.appendSections([.popular])
            snapshot.appendItems([artists.first!], toSection: .popular)
            
            let artists = artists
            let others = artists.dropFirst()
            
            if !others.isEmpty {
                snapshot.appendSections([.others])
                snapshot.appendItems(Array(others), toSection: .others)
            }
        }
        return snapshot
    }
    
    // MARK: - Alert Methods
    
    func showAlertForError(error: Error) {
        Alert.present(title: "Information",message: error.localizedDescription,actions: .okay, from: self)
    }
}
