import Dispatch
import Foundation

// Based on https://github.com/ishkawa/APIKit/blob/3.0.0/Tests/APIKitTests/TestComponents/HTTPStub.swift.
class HTTPStub: NSObject {
    static let shared: HTTPStub = HTTPStub()

    var stubRequests: ((URLRequest) -> FixtureType)!
    private var fixture: FixtureType!

    override static func initialize() {
        if self == HTTPStub.self {
            URLProtocol.registerClass(StubProtocol.self)
        }
    }

    private override init() {
        super.init()
    }

    private class StubProtocol: URLProtocol {
        private var isCancelled = false

        // MARK: - URLProtocol

        override static func canInit(with: URLRequest) -> Bool {
            return true
        }

        override static func canonicalRequest(for request: URLRequest) -> URLRequest {
            HTTPStub.shared.fixture = HTTPStub.shared.stubRequests(request)
            return request
        }

        override func startLoading() {
            let queue = DispatchQueue.global(qos: .default)

            queue.asyncAfter(deadline: .now() + 0.01) {
                guard !self.isCancelled else {
                    return
                }

                let fixture = HTTPStub.shared.fixture!
                self.client?.urlProtocol(self, didReceive: fixture.response, cacheStoragePolicy: .notAllowed)
                self.client?.urlProtocol(self, didLoad: fixture.data)
                self.client?.urlProtocolDidFinishLoading(self)
            }
        }

        override func stopLoading() {
            isCancelled = true
        }
    }
}
