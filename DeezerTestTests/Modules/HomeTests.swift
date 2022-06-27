//
//  HomeViewModelTests.swift
//  DeezerTestTests
//
//  Created by Nitesh Singh on 24/06/22.
//

import XCTest
import Foundation
import Combine
@testable import DeezerTest

class HomeViewModelTestCase: XCTestCase {

    private var mockChartsRepository: MockChartsRepository!
    private var chartsViewModel: HomeViewModel!
    private var homeScene: HomeViewController!
    private var cancellables: Set<AnyCancellable>!
    private var homeView: HomeListView!
    private var coordinator: AppCoordinator!
    
    private var service: NetworkService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockChartsRepository = MockChartsRepository()
        chartsViewModel = HomeViewModel(service: mockChartsRepository)
        homeView = HomeListView()
        
        coordinator = AppCoordinator()
        homeScene = ((coordinator.start() as? UITabBarController)?.viewControllers?.first as? UINavigationController)?.viewControllers.first as? HomeViewController
        
        let networkService = DefaultNetworkService(MockURLSession(data: FakeStub.generateFakeDataFromJSONWith(fileName: "ChartsMock"),response: FakeStub.responsePass,error: nil))
        
        mockChartsRepository.networkService = networkService
        
        homeScene.homeViewModel = chartsViewModel
        homeScene.setupCollectionView()
        homeScene.setupDatasource()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDownWithError() throws {
        mockChartsRepository = nil
        chartsViewModel = nil
        cancellables = nil
        homeView = nil
        homeScene = nil
        coordinator = nil
        try super.tearDownWithError()
    }
    
    func testIfDependenciesInitialized_homeView_andViewModel() throws {
        
        let expectation = XCTestExpectation(description: "Checking If Dependencies Are Loaded")
        XCTAssertTrue(homeScene.view.isKind(of: HomeListView.self))
        XCTAssertNotNil(homeScene.datasource)
        expectation.fulfill()
    }
    
    func testIfChartValuesReceived_andSectionsLoaded_afterNetworkAPICall() {
        let expectation = XCTestExpectation(description: "Checking If Sections Are Loaded With Data")
        
        homeScene.homeViewModel.$chart
            .dropFirst()
            .sink(receiveValue: { [weak self]  chart in
                XCTAssertNotNil(chart)
                self?.homeScene.updateSections(result: chart!)
                XCTAssertTrue(self?.homeScene.datasource.snapshot().numberOfSections == 5)
                XCTAssertTrue(self?.homeScene.datasource.snapshot().numberOfItems(inSection: .tracks) == 10)
                XCTAssertTrue(self?.homeScene.datasource.snapshot().numberOfItems(inSection: .albums) == 9)
                XCTAssertTrue(self?.homeScene.datasource.snapshot().numberOfItems(inSection: .tracks) == 10)
                XCTAssertTrue(self?.homeScene.datasource.snapshot().numberOfItems(inSection: .playlists) == 10)
                XCTAssertTrue(self?.homeScene.datasource.snapshot().numberOfItems(inSection: .podcasts) == 10)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        homeScene.homeViewModel.fetchChart()
        
        wait(for: [expectation], timeout: 1)
    }
}
