//
//  ApiPage.swift
//  BusquedaDragonBall
//
//  Created by Tardes on 28/1/26.
//

import Foundation

struct ApiPage<T: Codable>: Codable {
    let items: [T]
    let meta: Meta
    let links: Links

    struct Meta: Codable {
        let totalItems: Int
        let itemCount: Int
        let itemsPerPage: Int
        let totalPages: Int
        let currentPage: Int
    }

    struct Links: Codable {
        let first: String
        let previous: String?
        let next: String?
        let last: String
    }
}
