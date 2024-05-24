//
//  Bundle+Extensions.swift
//  ShoppingList
//
//  Created by fegrit.
//

import Foundation

extension Bundle {
    func decode<T: Decodable>(from filename: String) -> T {
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
            fatalError("Failed to locate \(filename) in app bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Не удалось загрузить \(filename) в пакете приложения.")
        }
        
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Не удалось декодировать \(filename) из пакета из-за отсутствия ключа '\(key.stringValue)' – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Не удалось декодировать \(filename) из пакета из-за несоответствия типа – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Не удалось декодировать \(filename) из пакета из-за отсутствия значения типа \(type) – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Не удалось декодировать \(filename) из пакета, так как JSON поврежден")
        } catch {
            fatalError("Не удалось декодировать \(filename) из пакета: \(error.localizedDescription)")
        }
    }
}
