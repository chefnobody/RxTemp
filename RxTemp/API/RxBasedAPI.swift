//
//  RxBasedAPI.swift
//  RxTemp
//
//  Created by Aaron Connolly on 8/20/21.
//

import RxSwift

struct RxBasedAPI {
    var fetchUser: () -> Observable<User>
    var fetchMovie: () -> Observable<Movie>
}

extension RxBasedAPI {
    static let mock = Self(
        fetchUser: { Observable.just(User.mock) },
        fetchMovie: { Observable.just(Movie.mock) }
    )
}
