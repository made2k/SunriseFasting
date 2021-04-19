//
//  PersistData.swift
//  Fasting
//
//  Created by Zach McGaughey on 4/16/21.
//

import Foundation

protocol ObjectSavable {
  func setObject<T>(_ object: T, forKey: String) throws where T: Encodable
  func getObject<T>(forKey: String) -> T? where T: Decodable
}

extension UserDefaults: ObjectSavable {
  
  func setObject<T>(_ object: T, forKey: String) throws where T: Encodable {
    let encoder = JSONEncoder()
    do {
      let data = try encoder.encode(object)
      set(data, forKey: forKey)
    } catch {
      print("error setting object: \(error)")
      throw ObjectSavableError.unableToEncode
    }
    
  }
  
  func getObject<T>(forKey: String) -> T? where T: Decodable {
    
    guard let data = data(forKey: forKey) else { return nil }
    
    let decoder = JSONDecoder()
    let object = try? decoder.decode(T.self, from: data)
    return object
    
  }
  
}

enum ObjectSavableError: String, LocalizedError {
  case unableToEncode = "Unable to encode object into data"
  case noValue = "No data object found for the given key"
  case unableToDecode = "Unable to decode object into given type"
  
  var errorDescription: String? {
    rawValue
  }
}
