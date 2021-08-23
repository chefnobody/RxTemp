//
//  UserViewModelTests.swift
//  RxTempTests
//
//  Created by Aaron Connolly on 8/23/21.
//

import RxTest
import RxSwift
import XCTest
@testable import RxTemp

final class UserViewModelTests: XCTestCase {
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
        
    override func setUp() {
        super.setUp()
        
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
    }
    
    func testBindFetchUserSuccessfullyFetchUserAndMovie() {
        let events = scheduler.createHotObservable([.next(100, ())])
                
        let vm = UserViewModel(
            rxAPI: RxBasedAPI(
                fetchUser: { Observable.just(User.mock) },
                fetchMovie: { Observable.just(Movie.mock) }
            )
        )
        
        let movieResults = scheduler.createObserver(Movie.self)
        
        scheduler.scheduleAt(0) {
            vm.bindFetchUser(events.asObservable())
            
            vm.movie
                .bind(to: movieResults)
                .disposed(by: self.disposeBag)
        }
        
        scheduler.start()
        
        let expectedMovie: [Recorded<Event<Movie>>] = [
            .next(100, Movie.mock)
        ]
        
        XCTAssertEqual(expectedMovie, movieResults.events)
    }
    
    func testBindFetchUserRxRoutesFetchUserErrors() {
        let events = scheduler.createHotObservable([.next(100, ())])
        
        let error = NSError(domain: "com.pizza.rxtest", code: 1, userInfo: nil)
        
        let vm = UserViewModel(
            rxAPI: RxBasedAPI(
                fetchUser: { Observable.error(error) },
                fetchMovie: { Observable.just(Movie.mock) }
            )
        )
        
        let errorResults = scheduler.createObserver(String.self)
        
        scheduler.scheduleAt(0) {
            vm.bindFetchUser(events.asObservable())
            
            vm.fetchUserError
                .map { $0.localizedDescription }
                .bind(to: errorResults)
                .disposed(by: self.disposeBag)
        }
        
        scheduler.start()
        
        let expectedErrors: [Recorded<Event<String>>] = [
            .next(100, "The operation couldn’t be completed. (com.pizza.rxtest error 1.)")
        ]
        
        XCTAssertEqual(expectedErrors, errorResults.events)
    }
    
    func testBindFetchUserRxRoutesFetchMovieErrors() {
        let events = scheduler.createHotObservable([.next(100, ())])
        
        let error = NSError(domain: "com.pizza.rxtest", code: 1, userInfo: nil)
        
        let vm = UserViewModel(
            rxAPI: RxBasedAPI(
                fetchUser: { Observable.just(User.mock) },
                fetchMovie: { Observable.error(error) }
            )
        )
        
        let errorResults = scheduler.createObserver(String.self)
        
        scheduler.scheduleAt(0) {
            vm.bindFetchUser(events.asObservable())
            
            vm.fetchMovieError
                .map { $0.localizedDescription }
                .bind(to: errorResults)
                .disposed(by: self.disposeBag)
        }
        
        scheduler.start()
        
        let expectedErrors: [Recorded<Event<String>>] = [
            .next(100, "The operation couldn’t be completed. (com.pizza.rxtest error 1.)")
        ]
        
        XCTAssertEqual(expectedErrors, errorResults.events)
    }
}
