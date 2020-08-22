import Foundation

enum NetworkError: Swift.Error {
    case `default`
    case wrongBaseUrl
    case notConnected
    case failedToDecode

    var localizedDescription: String {
        switch self {
        case .default, .failedToDecode, .wrongBaseUrl:
            return "Ocorreu um erro inesperado."
        case .notConnected:
            return "Sem conexão com a internet :("
        }
    }
}
