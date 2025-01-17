//
//  MoviesViewModel.swift
//  MoviesAppUIKit
//
//  Created by Rezaul Karim on 18/1/25.
//

import Foundation
import Combine

class MoviesViewModel{
    
    @Published private(set) var movies : [Movie] = []
    private let httpClient : HttpClient
    private var cancellables : Set<AnyCancellable> = []
    @Published var isLoadingCompleted : Bool = false
    
    private var searchSubject = CurrentValueSubject<String, Never>("")
    
    
    
    init (httpClient : HttpClient) {
        self.httpClient = httpClient
        setupSearchSubject()
    }
    
    private func setupSearchSubject(){
        searchSubject
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.loadMovies(search: searchText)
            }.store(in: &cancellables)
    }
    
    func setSearchText(searchText : String){
        searchSubject.send(searchText)
    }
    
    func loadMovies(search : String){
        httpClient.fetchMovies(search: search)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.isLoadingCompleted = true
                    print("finised")
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { [weak self] movies in
                self?.movies = movies
            }.store(in: &cancellables)
    }
    
    
    
}
