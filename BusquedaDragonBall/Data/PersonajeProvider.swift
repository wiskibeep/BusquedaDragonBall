//
//  PersonajeProvider.swift
//  BusquedaDragonBall
//
//  Created by Tardes on 28/1/26.
//

import Foundation

class PersonajeProvider {
    
    // Devuelve una página de personajes con meta y links
    static func obtenerPersonajes(page: Int, limit: Int) async -> ApiPage<Personaje.Item>? {
        var components = URLComponents(string: "\(Constants.SERVER_BASE_URL)/api/characters")
        components?.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "limit", value: String(limit))
        ]
        
        guard let url = components?.url else {
            print("Error al crear la URL")
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let resultado = try JSONDecoder().decode(ApiPage<Personaje.Item>.self, from: data)
            return resultado
        } catch {
            print("Invalido data")
            print("Invalido info : \(error)")
            return nil
        }
    }
    
    // Si el endpoint de detalle devuelve { items: [Item] }, tomamos el primero.
    static func obtenerUnPersonaje(id: Int) async -> Personaje.Item? {
        let url = URL(string: "\(Constants.SERVER_BASE_URL)/api/characters/\(id)")
        
        guard let url = url else {
            print("Error al crear la URL")
            return nil
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            // Algunos endpoints de detalle pueden devolver el item directamente en vez de una página.
            // Si es { items: [...] }, decodificamos ApiPage y tomamos el primero; si es un item directo, intentamos decodificar Item.
            if let page = try? JSONDecoder().decode(ApiPage<Personaje.Item>.self, from: data) {
                return page.items.first
            } else {
                let item = try JSONDecoder().decode(Personaje.Item.self, from: data)
                return item
            }
        } catch {
            print("Invalido data")
            print("Invalido info : \(error)")
            return nil
        }
    }
}
