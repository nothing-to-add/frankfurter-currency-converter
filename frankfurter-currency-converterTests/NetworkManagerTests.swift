import XCTest
@testable import frankfurter_currency_converter

final class NetworkManagerTests: XCTestCase {
    private var networkManager: NetworkManager!
    private var mockHTTPClient: MockHTTPClient!
    
    override func setUp() {
        super.setUp()
        mockHTTPClient = MockHTTPClient()
        networkManager = NetworkManager(httpClient: mockHTTPClient)
    }
    
    override func tearDown() {
        networkManager = nil
        mockHTTPClient = nil
        super.tearDown()
    }
    
    func testFetchDataSuccess() async throws {
        // Arrange
        let expectedData = TestModel(id: 1, name: "Test")
        let jsonData = try JSONEncoder().encode(expectedData)
        mockHTTPClient.result = .success((jsonData, HTTPURLResponse()))
        
        // Act
        let result: TestModel = try await networkManager.fetchData(from: "https://example.com", as: TestModel.self)
        
        // Assert
        XCTAssertEqual(result, expectedData)
    }
    
    func testFetchDataFailure() async {
        // Arrange
        mockHTTPClient.result = .failure(NetworkError.invalidURL)
        
        // Act & Assert
        do {
            _ = try await networkManager.fetchData(from: "https://example.com", as: TestModel.self)
            XCTFail("Expected invalid URL error, but no error was thrown.")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.invalidURL)
        }
    }
    
    func testFetchDataDecodingError() async {
        // Arrange
        let invalidJsonData = Data("Invalid JSON".utf8)
        mockHTTPClient.result = .success((invalidJsonData, HTTPURLResponse()))
        
        // Act & Assert
        do {
            _ = try await networkManager.fetchData(from: "https://example.com", as: TestModel.self)
            XCTFail("Expected decoding error, but no error was thrown.")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.decodingError)
        }
    }
}

// Mock HTTPClient
final class MockHTTPClient: HTTPClient {
    var result: Result<(Data, HTTPURLResponse), Error>?
    
    func get(from urlString: String) async throws -> Result<(Data, HTTPURLResponse), Error> {
        guard let result = result else {
            throw NetworkError.invalidURL
        }
        return result
    }
}

// Test Model
struct TestModel: Codable, Equatable {
    let id: Int
    let name: String
}
