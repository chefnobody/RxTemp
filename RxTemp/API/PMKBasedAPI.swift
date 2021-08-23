//
//  PMKBasedAPI.swift
//  RxTemp
//
//  Created by Aaron Connolly on 8/22/21.
//

import PromiseKit

struct PMKBasedAPI {
    var fetchUser: () -> Promise<User>
    var fetchMovie: () -> Promise<Movie>
}

extension PMKBasedAPI {
    static let mock = Self(
        fetchUser: { Promise.value(User.mock) },
        fetchMovie: { Promise.value(Movie.mock) }
    )
}
