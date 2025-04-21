import XCTest
@testable import frankfurter_currency_converter

final class CurrencyViewModelTests: XCTestCase {

    var viewModel: CurrencyViewModel!
    var mockCurrencyFetcher: MockCurrencyFetcher!

    override func setUp() {
        super.setUp()
        mockCurrencyFetcher = MockCurrencyFetcher()
        viewModel = CurrencyViewModel(currencyFetcher: mockCurrencyFetcher)
    }

    override func tearDown() {
        viewModel = nil
        mockCurrencyFetcher = nil
        super.tearDown()
    }

    func testFetchCurrenciesSuccess() async {
        // Arrange
        let mockResponse = Response(amount: 1.0, base: "EUR", date: "", rates: ["USD": 1.1, "GBP": 0.9])
        mockCurrencyFetcher.mockResponse = .success(mockResponse)

        // Act
        await viewModel.fetchCurrencies(base: "EUR")

        // Assert
        XCTAssertEqual(viewModel.currencies.count, 2)
        XCTAssertEqual(viewModel.currencies.first?.code, "GBP") // Sorted alphabetically
    }

    func testFetchCurrenciesFailure() async {
        // Arrange
        mockCurrencyFetcher.mockResponse = .failure(NetworkError.serverError("Mock error"))

        // Act
        await viewModel.fetchCurrencies(base: "EUR")

        // Assert
        XCTAssertTrue(viewModel.currencies.isEmpty)
    }

    func testSelectCurrency() async {
        // Arrange
        let mockResponse = Response(amount: 1.0, base: "USD", date: "", rates: ["EUR": 0.9, "GBP": 0.8])
        mockCurrencyFetcher.mockResponse = .success(mockResponse)

        // Act
        viewModel.selectCurrency(Currency(code: "USD", rate: 1.0))
        try? await Task.sleep(nanoseconds: 500_000_000) // Wait for async task to complete

        // Assert
//        XCTAssertEqual(viewModel.currencyBase, "USD")
        XCTAssertEqual(viewModel.currencies.count, 2)
    }

    func testUpdateRates() {
        // Arrange
        viewModel.selectedCurrency = Currency(code: "EUR", rate: 1.0)
        viewModel.currencies = [Currency(code: "USD", rate: 1.1), Currency(code: "GBP", rate: 0.9)]

        // Act
        viewModel.updateRates(for: 2.0)

        // Assert
        XCTAssertEqual(viewModel.getCurrencyValue(for: viewModel.currencies[0]), "2.20")
        XCTAssertEqual(viewModel.getCurrencyValue(for: viewModel.currencies[1]), "1.80")
    }
}

// Mock implementation of CurrencyFetcher
final class MockCurrencyFetcher: CurrencyFetcherProtocol {
    var mockResponse: Result<Response, Error>?

    func fetchRates(for base: String) async throws -> Response {
        if let response = mockResponse {
            switch response {
            case .success(let data):
                return data
            case .failure(let error):
                throw error
            }
        }
        throw NetworkError.noData
    }
}
