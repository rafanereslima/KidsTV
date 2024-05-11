//
//  APIKEY.swift
//  KidsVIdeoSuggest
//
//  Created by Rafael Neres Lima on 10/05/24.
//

import Foundation

enum APIKey {
  // Fetch the API key from `GeminiAI-Info.plist`
  static var `default`: String {
    guard let filePath = Bundle.main.path(forResource: "GeminiAI-Info", ofType: "plist")
    else {
      fatalError("Arquivo de configuracao nao encontrado 'GenerativeAI-Info.plist'.")
    }
    let plist = NSDictionary(contentsOfFile: filePath)
    guard let value = plist?.object(forKey: "API_KEY") as? String else {
      fatalError("Nao foi localizada sua 'API_KEY' em 'GeminiAI-Info.plist'.")
    }
    if value.starts(with: "_") {
      fatalError(
        "Acesse https://ai.google.dev/tutorials/setup para ter acesso a uma API key."
      )
    }
    return value
  }
}
