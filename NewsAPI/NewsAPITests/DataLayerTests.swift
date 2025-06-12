import XCTest
@testable import NewsAPI
final class DataLayerTests: XCTestCase {
    var networkServiceMock: NetworkServiceMock!
        var sut: NewsAPIService!
    
    let sampleJSON = """
    {
        "status": "ok",
        "totalResults": 1,
        "articles": [
            {
                "source": { "id": null, "name": "Example" },
                "author": "Author Name",
                "title": "Test Title",
                "description": "Test Description",
                "url": "https://example.com",
                "urlToImage": "https://example.com/image.jpg",
                "publishedAt": "2025-06-12T12:00:00Z",
                "content": "Test Content"
            }
        ]
    }
    """.data(using: .utf8)!
        
        override func setUp() {
            super.setUp()
            networkServiceMock = NetworkServiceMock()
            sut = NewsAPIService(networkService: networkServiceMock)
        }
        
        override func tearDown() {
            networkServiceMock = nil
            sut = nil
            super.tearDown()
        }
        
        func testFetchNews_Success() async throws {
            networkServiceMock.resultToReturn = .success(sampleJSON)
            
            let response = try await sut.fetchNews(query: "apple")
            
            XCTAssertEqual(response.status, "ok")
            XCTAssertEqual(response.totalResults, 1)
            XCTAssertEqual(response.articles.first?.title, "Test Title")
        }
        
        func testFetchNews_Failure() async {
            networkServiceMock.resultToReturn = .failure(NewsError.invalidURL)
            
            do {
                _ = try await sut.fetchNews(query: "apple")
                XCTFail("Expected to throw error but did not")
            } catch {
                XCTAssertEqual(error as? NewsError, NewsError.invalidURL)
            }
        }
        
        func testBuildNewsURL_IsValid() throws {
            let url = try sut.buildNewsURL(query: "apple")
            let urlString = url.absoluteString
            
            XCTAssertTrue(urlString.contains("q=apple"))
            XCTAssertTrue(urlString.contains("apiKey=\(sut.apiKey)"))
            XCTAssertTrue(urlString.contains("everything"))
        }
        
        func testBuildTopHeadlinesURL_IsValid() throws {
            let url = try sut.buildTopHeadlinesURL(category: "business")
            let urlString = url.absoluteString
            
            XCTAssertTrue(urlString.contains("category=business"))
            XCTAssertTrue(urlString.contains("top-headlines"))
            XCTAssertTrue(urlString.contains("apiKey=\(sut.apiKey)"))
        }

}
