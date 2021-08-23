//
//  UserViewModel.swift
//  RxTemp
//
//  Created by Aaron Connolly on 8/22/21.
//

import Foundation
import PromiseKit
import RxSwift

final class UserViewModel {
    
    // MARK: Public properties
    
    var movie: Observable<Movie> { movieSubject }
    
    var fetchUserError: Observable<Error> { fetchUserErrorRouter.error }
    var fetchMovieError: Observable<Error> { fetchMovieErrorRouter.error }
    
    // MARK: Private variables
    
    private let disposeBag = DisposeBag()
    private let movieSubject = PublishSubject<Movie>()
    private let fetchUserErrorRouter = ErrorRouter()
    private let fetchMovieErrorRouter = ErrorRouter()
    
    private let rxAPI: RxBasedAPI?
    private let pmkAPI: PMKBasedAPI?
        
    init(rxAPI: RxBasedAPI) {
        self.rxAPI = rxAPI
        self.pmkAPI = nil
    }
    
    init(pmkAPI: PMKBasedAPI) {
        self.rxAPI = nil
        self.pmkAPI = pmkAPI
    }
    
    func bindFetchUser(_ observable: Observable<Void>) {
        observable
            .flatMap { [weak self] _ -> Observable<User> in
                guard let self = self else { return .empty() }
                return self.fetchUser().rerouteError(self.fetchUserErrorRouter)
            }
            .flatMap { [weak self] _ -> Observable<Movie> in
                guard let self = self else { return .empty() }
                return self.fetchMovie().rerouteError(self.fetchMovieErrorRouter)
            }
            .subscribe(
                onNext: { [weak self] movie in
                    print("All done \(movie)!")
                    self?.movieSubject.onNext(movie)
                }
            )
            .disposed(by: disposeBag)
    }
    
    // MARK: Private methods
    
    private func fetchUser() -> Observable<User> {
        if let rxAPI = rxAPI {
            return rxAPI.fetchUser()
        }
        
        return fetchUserPMK()
    }
    
    private func fetchMovie() -> Observable<Movie> {
        if let rxAPI = rxAPI {
            return rxAPI.fetchMovie()
        }
        
        return fetchMoviePMK()
    }
    
    // Creates an Observable from a PromiseKit-based API...
    private func fetchUserPMK() -> Observable<User> {
        guard let pmkAPI = self.pmkAPI else { return .empty() }
        return Observable<User>.create { observer in
            pmkAPI.fetchUser()
                .done {
                    observer.onNext($0)
                    observer.onCompleted()
                }
                .catch(observer.onError(_:))
            
            return Disposables.create()
        }
    }
    
    // Creates an Observable from a PromiseKit-based API...
    private func fetchMoviePMK() -> Observable<Movie> {
        guard let pmkAPI = self.pmkAPI else { return .empty() }
        return Observable<Movie>.create { observer in
            pmkAPI.fetchMovie()
                .done {
                    observer.onNext($0)
                    observer.onCompleted()
                }
                .catch(observer.onError(_:))
            
            return Disposables.create()
        }
    }
}
