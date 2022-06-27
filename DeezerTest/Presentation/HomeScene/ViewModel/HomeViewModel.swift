//
//  HomeListViewModel.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 20/06/22.
//

import Foundation
import Combine

enum ViewModelState {
    case loading
    case finished
    case error(Error)
}

final class HomeViewModel {
    
    // MARK: - Section
    
    enum Section: String, CaseIterable {
        case tracks
        case artists
        case albums
        case playlists
        case podcasts
        
        var localized: String {
            switch self {
            case .tracks:
                return "top_tracks".localized
            case .artists:
                return "top_artists".localized
            case .albums:
                return "top_albums".localized
            case .playlists:
                return "top_playlists".localized
            case .podcasts:
                return "top_podcasts".localized
            }
        }
    }
    
    // MARK: - Properties
    
    @Published var chart: Chart?
    @Published var state: ViewModelState = .loading
    
    var bindings = Set<AnyCancellable>()
    var service: ChartsRepository
    
    // MARK: - Initializer
    
    init(service: ChartsRepository) {
        self.service = service
    }
    
    // MARK: - Methods
    
    func fetchChart() {
        state = .loading
        
        let completionHandler: (Subscribers.Completion<NetworkError>) -> Void = { [weak self] (completion) in
            
            switch completion {
            case .finished:
                self?.state = .finished
            case .failure(let error):
                self?.state = .error(error)
            }
        }
        
        let valueHandler: (Chart) -> Void = { [weak self] (chart) in
            self?.chart = chart
        }
        
        service.fetchCharts(endpoint: .chart)
            .sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
            .store(in: &bindings)
    }
}
