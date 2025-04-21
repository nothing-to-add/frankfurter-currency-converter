import XCTest
@testable import frankfurter_currency_converter

final class CurrencyFetcherTests: XCTestCase {
    private var currencyFetcher: CurrencyFetcher!
    private var mockHTTPClient: MockHTTPClient!

    override func setUp() {
        super.setUp()
        mockHTTPClient = MockHTTPClient()
        currencyFetcher = CurrencyFetcher(networkClient: mockHTTPClient)
    }

    override func tearDown() {
        currencyFetcher = nil
        mockHTTPClient = nil
        super.tearDown()
    }

    func testFetchRatesSuccess() async throws {
        // Arrange
        let expectedResponse = Response(amount: 1.0, base: "USD", date: "2025-04-22", rates: ["USD": 1.0, "EUR": 0.9])
        let jsonData = try JSONEncoder().encode(expectedResponse)
        mockHTTPClient.result = .success((jsonData, HTTPURLResponse()))

        // Act
        let result = try await currencyFetcher.fetchRates(for: "USD")

        // Assert
        XCTAssertEqual(result, expectedResponse)
    }
}
