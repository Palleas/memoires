import Foundation

protocol StateTokenFactory {
    associatedtype TokenType: CustomStringConvertible
    
    func generate() -> TokenType
}

struct StringTokenFactory: StateTokenFactory {
    
    func generate() -> String {
        return UUID().uuidString
    }
    
}
