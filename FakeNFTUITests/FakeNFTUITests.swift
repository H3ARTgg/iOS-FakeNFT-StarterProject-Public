import XCTest

final class FakeNFTUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    // MARK: StatisticFlow
    func testRatingView() {
        sleep(1)
        
        let tablesQuery = app.tables["Image list"]
        XCTAssertTrue(tablesQuery.waitForExistence(timeout: 3))
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        cell.swipeUp()
        sleep(1)
        
        cell.tap()
        sleep(1)
        
        app.buttons["User site"].tap()
        let webViewQuery = app.webViews["NftWebView"]
        XCTAssertTrue(webViewQuery.waitForExistence(timeout: 5))
        sleep(2)
        
        webViewQuery.swipeUp()
        sleep(1)
        
        webViewQuery.swipeDown()
        sleep(1)
        
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        app.buttons["User collection"].tap()
        sleep(1)
      
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()
    
        XCTAssertTrue(tablesQuery.waitForExistence(timeout: 3))
    }
}
