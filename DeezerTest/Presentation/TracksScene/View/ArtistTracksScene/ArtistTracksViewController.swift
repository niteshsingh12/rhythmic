//
//  ArtistTracksViewController.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 24/06/22.
//

import Foundation
import UIKit
import Combine

class ArtistTracksViewController: UIViewController {
    
    // MARK: - Properties
    
    var contentView: TracksDetailView
    var trackViewModel: TrackViewModel
    var coordinator: Coordinator?
    var artist: Artist?
    var parentType: TracksType = .artist
    
    var cancellableSet = Set<AnyCancellable>()
    let imageRepository: ImageRepository
    var isLoadingList : Bool = false
    var tracks = [Track]()
    var miniPlayer: MiniPlayerViewController?
    var tracksRequest: TracksRequest?
    
    // MARK: - Initializer
    
    init(artist: Artist?, contentView: TracksDetailView, viewModel: TrackViewModel, imageRepository: ImageRepository) {
        self.artist = artist
        self.contentView = contentView
        self.trackViewModel = viewModel
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
        setupTableView()
        setupBindings()
        fetchTrackListDetails()
        addContentViewInsetIfMiniPlayerIsOn()
        
        //contentView.tracksTableView.tableHeaderView.bo = 0.0
        contentView.tracksTableView.tableHeaderView = contentView.imageContentView
        //contentView.tracksTableView.layoutIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let artist = artist, let imageURL = artist.picture_big else { return }
        self.imageRepository.cancelLoad(imageURL)
    }
    
    // MARK: - Methods
    
    func addContentViewInsetIfMiniPlayerIsOn() {
        if isMiniPlayerVisible {
            self.view.backgroundColor = .systemBackground
            self.contentView.tracksTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: miniPlayerHeight, right: 0)
        }
    }
    
    func fetchTrackListDetails() {
        
        guard let artist = artist else { return }
        
        let trackFetchRequest = TracksRequest(id: artist.id)
        tracksRequest = trackFetchRequest
        trackViewModel.fetchTracks(request: trackFetchRequest)
        updateContentViewData()
    }
    
    func updateContentViewData() {
        
        guard let artist = artist else { return }
        contentView.titleVLabel.text = artist.name
        if let fans = artist.nb_fan {
            contentView.subtitleLabel.text = String(fans) + " Fans"
        }
        if let imageURL = artist.picture_big {
            fetchImageWith(url: imageURL)
        }
    }
    
    func fetchImageWith(url: String) {
        
        imageRepository.loadImage(urlString: url)
            .sink(receiveCompletion: { completion in
                
                switch completion {
                case .failure(let error): print(error)
                default: ()
                }
            }, receiveValue: { (image) in
                self.contentView.coverImageView.image = image
            })
            .store(in: &cancellableSet)
    }
    
    func setupBindings() {
        
        trackViewModel.tracks
            .sink(receiveCompletion: {_ in
                
            }, receiveValue: { [weak self] tracks in
                
                guard let self = self else { return }
                self.tracks.append(contentsOf: tracks.data)
                
                DispatchQueue.main.async {
                    
                    self.contentView.tracksTableView.reloadData()
                    self.contentView.trackCountLabel.text = String(tracks.total) + " Tracks"
                }
            })
            .store(in: &cancellableSet)
        
        trackViewModel.$state
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
    
    func loadMoreTracks() {
        
        guard let artist = artist else { return }
        isLoadingList = true
        let tracksFetchRequest = TracksRequest(id: artist.id, index: tracks.count)
        tracksRequest = tracksFetchRequest
        trackViewModel.fetchTracks(request: tracksFetchRequest)
    }
    
    // MARK: - Alert Methods
    
    func showAlertForError(error: Error) {
        Alert.present(title: "Information",message: error.localizedDescription, actions: .retry(handler: {
            self.trackViewModel.fetchTracks(request: self.tracksRequest!)
        }), .okay, from: self)
    }
}

// MARK: - Pagination

extension ArtistTracksViewController {
    
    ///Pagination Logic
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if ((contentView.tracksTableView.contentOffset.y + contentView.tracksTableView.frame.size.height) >= contentView.tracksTableView.contentSize.height)
        {
            if !isLoadingList {
                loadMoreTracks()
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isLoadingList = false
    }
}
