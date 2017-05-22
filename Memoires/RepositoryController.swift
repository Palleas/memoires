import Foundation
import ReactiveSwift
import Tentacle

final class RepositoryController {

    private let client: Client
    
    init(client: Client) {
        self.client = client
    }
    
    func all() -> SignalProducer<[RepositoryInfo], Client.Error> {
        return client.repositories().collect().map {
            $0.flatMap { $0.1 }
        }
    }
}
