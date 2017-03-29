//
//  Fixtures.swift
//  Tentacle
//
//  Created by Matt Diephouse on 3/3/16.
//  Copyright © 2016 Matt Diephouse. All rights reserved.
//

import Argo
import Foundation
@testable import Tentacle

/// A dummy class, so we can ask for the current bundle in Fixture.URL
private class ImportedWithFixture { }

protocol FixtureType {
    var url: URL { get }
    var contentType: String { get }
}

protocol EndpointFixtureType: FixtureType {
    var server: Server { get }
    var endpoint: Client.Endpoint { get }
    var page: UInt? { get }
    var pageSize: UInt? { get }
}

extension FixtureType {
    /// The filename used for the local fixture, without an extension
    private func filename(withExtension ext: String) -> String {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)!

        let path = (components.path as NSString)
            .pathComponents
            .dropFirst()
            .joined(separator: "-")
        
        let query = components.queryItems?
            .map { item in
                if let value = item.value {
                    return "\(item.name)-\(value)"
                } else {
                    return item.name
                }
            }
            .joined(separator: "-")
        
        if let query = query, query != "" {
            return "\(path).\(query).\(ext)"
        }
        return "\(path).\(ext)"
    }
    
    /// The filename used for the local fixture's data.
    var dataFilename: String {
        return filename(withExtension: Fixture.DataExtension)
    }
    
    /// The filename used for the local fixture's HTTP response.
    var responseFilename: String {
        return filename(withExtension: Fixture.ResponseExtension)
    }
    
    private func fileURL(withExtension ext: String) -> URL {
        let filename = self.filename(withExtension: ext) as NSString
        #if SWIFT_PACKAGE
            return URL(fileURLWithPath: #file)
                .deletingLastPathComponent()
                .appendingPathComponent("Fixtures")
                .appendingPathComponent(filename as String)
        #else
            let bundle = Bundle(for: ImportedWithFixture.self)
            return bundle.url(forResource: filename.deletingPathExtension, withExtension: filename.pathExtension)!
        #endif
    }
    
    /// The URL of the fixture's data within the test bundle.
    var dataFileURL: URL {
        return fileURL(withExtension: Fixture.DataExtension)
    }
    
    /// The URL of the fixture's HTTP response within the test bundle.
    var responseFileURL: URL {
        return fileURL(withExtension: Fixture.ResponseExtension)
    }
    
    /// The data from the endpoint.
    var data: Data {
       return (try! Data(contentsOf: dataFileURL))
    }
    
    /// The HTTP response from the endpoint.
    var response: HTTPURLResponse {
        let data = try! Data(contentsOf: responseFileURL)
        return NSKeyedUnarchiver.unarchiveObject(with: data) as! HTTPURLResponse
    }
}

extension EndpointFixtureType {
    /// The URL of the fixture on the API.
    var url: URL {
        return URL(self.server, self.endpoint, page: page, pageSize: pageSize)
    }
    
    /// The JSON from the Endpoint.
    var JSON: Any {
        return try! JSONSerialization.jsonObject(with: data)
    }
    
    /// Decode the fixture's JSON as an object of the returned type.
    func decode<Object: Decodable>() -> Object? where Object.DecodedType == Object {
        let decoded: Decoded<Object> = Argo.decode(JSON)
        if case let .failure(error) = decoded {
            print("Failure: \(error)")
        }

        return Argo.decode(JSON).value
    }
    
    /// Decode the fixture's JSON as an array of objects of the returned type.
    func decode<Object: Decodable>() -> [Object]? where Object.DecodedType == Object {
        let decoded: Decoded<[Object]> = Argo.decode(JSON)
        if case let .failure(error) = decoded {
            print("Failure from collection: \(error)")
        }

        return Argo.decode(JSON).value
    }
}

struct Fixture {
    fileprivate static let DataExtension = "data"
    fileprivate static let ResponseExtension = "response"
    
    static var allFixtures: [FixtureType] = [
        Release.Carthage0_15,
        Release.MDPSplitView1_0_2,
        Release.Nonexistent,
        Release.TagOnly,
        Release.Asset.MDPSplitView_framework_zip,
        Releases.Carthage[0],
        Releases.Carthage[1],
        UserInfo.mdiep,
        UserInfo.test,
        IssuesInRepository.PalleasOpensource,
        CommentsOnIssue.CommentsOnIssueInSampleRepository,
        RepositoriesForUser.RepositoriesForPalleasOpensource,
        RepositoriesForOrganization.RepositoriesForRACCommunity,
        FileForRepository.ReadMeForSampleRepository,
        FileForRepository.SubmoduleInTentacle,
        FileForRepository.DirectoryInSampleRepository,
        FileForRepository.SymlinkInSampleRepository,
        BranchesForRepository.BranchesInReactiveTask
    ]
    
    /// Returns the fixture for the given URL, or nil if no such fixture exists.
    static func fixtureForURL(_ url: URL) -> FixtureType? {
        return allFixtures.first { $0.url == url }
    }
    
    struct Release: EndpointFixtureType {
        static let Carthage0_15 = Release(.dotCom, owner: "Carthage", name: "Carthage", tag: "0.15")
        static let MDPSplitView1_0_2 = Release(.dotCom, owner: "mdiep", name: "MDPSplitView", tag: "1.0.2")
        static let Nonexistent = Release(.dotCom, owner: "mdiep", name: "NonExistent", tag: "tag")
        static let TagOnly = Release(.dotCom, owner: "torvalds", name: "linux", tag: "v4.4")
        
        let server: Server
        let repository: Repository
        let tag: String
        let page: UInt? = nil
        let pageSize: UInt? = nil
        let contentType = Client.APIContentType
        
        var endpoint: Client.Endpoint {
            return .releaseByTagName(owner: repository.owner, repository: repository.name, tag: tag)
        }
        
        init(_ server: Server, owner: String, name: String, tag: String) {
            self.server = server
            repository = Repository(owner: owner, name: name)
            self.tag = tag
        }
        
        struct Asset: FixtureType {
            static let MDPSplitView_framework_zip = Asset("https://api.github.com/repos/mdiep/MDPSplitView/releases/assets/433845")
            
            let url: URL
            let contentType = Client.DownloadContentType
            
            init(_ URLString: String) {
                url = URL(string: URLString)!
            }
        }
    }
    
    struct Releases: EndpointFixtureType {
        static let Carthage = [
            Releases(.dotCom, "Carthage", "Carthage", 1, 30),
            Releases(.dotCom, "Carthage", "Carthage", 2, 30),
        ]
        
        let server: Server
        let repository: Repository
        let page: UInt?
        let pageSize: UInt?
        let contentType = Client.APIContentType
        
        var endpoint: Client.Endpoint {
            return .releasesInRepository(owner: repository.owner, repository: repository.name)
        }
        
        init(_ server: Server, _ owner: String, _ name: String, _ page: UInt, _ pageSize: UInt) {
            self.server = server
            repository = Repository(owner: owner, name: name)
            self.page = page
            self.pageSize = pageSize
        }
    }
    
    struct UserInfo: EndpointFixtureType {
        static let mdiep = UserInfo(.dotCom, "mdiep")
        static let test = UserInfo(.dotCom, "test")
        
        let server: Server
        let login: String
        
        let page: UInt? = nil
        let pageSize: UInt? = nil
        let contentType = Client.APIContentType
        
        var endpoint: Client.Endpoint {
            return .userInfo(login: login)
        }
        
        init(_ server: Server, _ login: String) {
            self.server = server
            self.login = login
        }
    }

    struct IssuesInRepository: EndpointFixtureType {
        static let PalleasOpensource = IssuesInRepository(.dotCom, "Palleas-opensource", "Sample-repository")

        let server: Server

        var endpoint: Client.Endpoint {
            return .issuesInRepository(owner: owner, repository: repository)
        }

        let page: UInt? = nil
        let pageSize: UInt? = nil
        let contentType = Client.APIContentType

        let owner: String
        let repository: String

        init(_ server: Server, _ owner: String, _ repository: String) {
            self.server = server
            self.owner = owner
            self.repository = repository
        }
    }

    struct CommentsOnIssue: EndpointFixtureType {
        static let CommentsOnIssueInSampleRepository = CommentsOnIssue(.dotCom, 1, "Palleas-Opensource", "Sample-repository")

        let server: Server
        let page: UInt? = nil
        let pageSize: UInt? = nil

        let number: Int
        let owner: String
        let repository: String

        let contentType = Client.APIContentType

        var endpoint: Client.Endpoint {
            return .commentsOnIssue(number: number, owner: owner, repository: repository)
        }

        init(_ server: Server, _ number: Int, _ owner: String, _ repository: String) {
            self.server = server
            self.number = number
            self.owner = owner
            self.repository = repository
        }
    }

    struct RepositoriesForUser: EndpointFixtureType {
        static let RepositoriesForPalleasOpensource = RepositoriesForUser(.dotCom, "Palleas-Opensource")
        
        let server: Server
        let page: UInt? = nil
        let pageSize: UInt? = nil

        let owner: String

        let contentType = Client.APIContentType

        var endpoint: Client.Endpoint {
            return .repositoriesForUser(user: owner)
        }

        init(_ server: Server, _ owner: String) {
            self.server = server
            self.owner = owner
        }
    }

    struct RepositoriesForOrganization: EndpointFixtureType {
        static let RepositoriesForRACCommunity = RepositoriesForOrganization(.dotCom, "raccommunity")

        let server: Server
        let page: UInt? = nil
        let pageSize: UInt? = nil

        let organization: String

        let contentType = Client.APIContentType

        var endpoint: Client.Endpoint {
            return .repositoriesForOrganization(organization: organization)
        }

        init(_ server: Server, _ organization: String) {
            self.server = server
            self.organization = organization
        }
    }

    struct FileForRepository: EndpointFixtureType {
        static let ReadMeForSampleRepository = FileForRepository(.dotCom, owner: "Palleas-opensource", repository: "Sample-repository", path: "README.md")
        static let SubmoduleInTentacle = FileForRepository(.dotCom, owner: "mdiep", repository: "Tentacle", path: "Carthage/Checkouts/ReactiveSwift")
        static let DirectoryInSampleRepository = FileForRepository(.dotCom, owner: "Palleas-opensource", repository: "Sample-repository", path: "Tools")
        static let SymlinkInSampleRepository = FileForRepository(.dotCom, owner: "Palleas-opensource", repository: "Sample-repository", path: "Tools/say")

        let server: Server
        let page: UInt? = nil
        let pageSize: UInt? = nil

        let owner: String
        let repository: String
        let path: String

        let contentType = Client.APIContentType

        var endpoint: Client.Endpoint {
            return .content(owner: owner, repository: repository, path: path, ref: nil)
        }

        init(_ server: Server, owner: String, repository: String, path: String) {
            self.server = server
            self.owner = owner
            self.repository = repository
            self.path = path
        }

    }

    struct BranchesForRepository: EndpointFixtureType {
        static let BranchesInReactiveTask = BranchesForRepository(.dotCom, owner: "Carthage", repository: "ReactiveTask")

        let server: Server
        let page: UInt? = nil
        let pageSize: UInt? = nil

        let owner: String
        let repository: String

        let contentType = Client.APIContentType

        var endpoint: Client.Endpoint {
            return .branches(owner: owner, repository: repository)
        }

        init(_ server: Server, owner: String, repository: String) {
            self.server = server
            self.owner = owner
            self.repository = repository
        }

    }
}
