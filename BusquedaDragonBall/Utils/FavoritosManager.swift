import Foundation

class FavoritosManager {
    static let shared = FavoritosManager()
    private let key = "favoriteCharacterIDs"
    
    private init() {}
    
    func favoritos() -> [Int] {
        UserDefaults.standard.array(forKey: key) as? [Int] ?? []
    }
    
    func esFavorito(id: Int) -> Bool {
        favoritos().contains(id)
    }
    
    func alternarFavorito(id: Int) {
        var ids = favoritos()
        if let index = ids.firstIndex(of: id) {
            ids.remove(at: index)
        } else {
            ids.append(id)
        }
        UserDefaults.standard.set(ids, forKey: key)
    }
}
