//
//  ArtistSearchViewModel.swift
//  DeezerTest
//
//  Created by Nitesh Singh on 23/06/22.
//

import Foundation
import Combine

final class ArtistSearchViewModel {
    
    // MARK: - Sections
    
    enum Section: String, CaseIterable {
        case popular
        case others
        
        var localized: String {
            switch self {
            case .popular:
                return "popular".localized
            case .others:
                return "others".localized
            }
        }
    }
    
    // MARK: - Properties
    
    @Published var artists: [Artist] = []
    @Published var state: ViewModelState = .loading
    
    var nextURL: String?
    var bindings = Set<AnyCancellable>()
    
    var service: SearchArtistsRepository
    
    // MARK: - Initializers
    
    init(service: SearchArtistsRepository) {
        self.service = service
    }
    
    // MARK: - Methods
    
    func searchArtists(request: ArtistSearch) {
        state = .loading
        
        let completionHandler: (Subscribers.Completion<NetworkError>) -> Void = { [weak self] (completion) in
            
            switch completion {
            case .finished: ()
                self?.state = .finished
            case .failure(let error):
                self?.state = .error(error)
            }
        }
        
        let valueHandler: (ArtistSearchWrapper<Artist>) -> Void = { [weak self] (artists) in
            self?.nextURL = artists.next
            self?.artists = artists.data
        }
        
        service.fetchArtists(endpoint: .search(request: request))
            .sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
            .store(in: &bindings)
    }
}
