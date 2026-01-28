//
//  Personaje.swift
//  BusquedaDragonBall
//
//  Created by Tardes on 28/1/26.
//

import Foundation

struct Personaje: Codable {
    let items: [Item]

    struct Item: Codable {
        let id: Int
        let name: String
        let ki: String
        let maxKi: String
        let race: String
        let gender: String
        let description: String
        let affiliation: String
        let image: String?
    }
}
