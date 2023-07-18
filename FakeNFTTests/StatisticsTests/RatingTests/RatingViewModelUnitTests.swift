@testable import FakeNFT
import XCTest

final class RatingViewModelUnitTests: XCTestCase {
    let statisticProviderSpy = StatisticProviderSpy()
    let sortStore = SortingStoreSpy()
    lazy var viewModel = RatingViewModelSpy(
        statisticProvider: statisticProviderSpy,
        sortStore: sortStore
    )
    
    func testRatingViewModelFetchedUsers() {
        let userCount = statisticProviderSpy.mockUsers.count
        viewModel.fetchUsers()
        XCTAssertEqual(viewModel.users.count, userCount)
    }
    
    func testRatingViewModelShowTableViewAndHidePlugLabel() {
        viewModel.fetchUsers()
        
        viewModel.showTableView = { isShow in
            XCTAssertTrue(isShow)
        }
        
        viewModel.showPlugView = { isShow, testText in
            XCTAssertFalse(isShow)
            XCTAssertNotNil(testText)
        }
    }
    
    func testRatingViewModelHideTableViewAndShowPlugLabel() {
        viewModel.showTableView = { isShow in
            XCTAssertFalse(isShow)
        }
        
        viewModel.showPlugView = { isShow, testText in
            XCTAssertFalse(isShow)
            XCTAssertNil(testText)
        }
    }
    
    func testRatingViewModelCallsDidSelectUser() {
        viewModel.fetchUsers()
        let userIndex = Int.random(in: 0..<statisticProviderSpy.mockUsers.count)
        viewModel.didSelectUser(at: userIndex)
        XCTAssertNotNil(viewModel.selectedUser)
    }
    
    func testRatingViewModelCallsSortedButtonTapped() {
        viewModel.sortedButtonTapped()
        XCTAssertTrue(viewModel.sortedButtonStatus)
    }
    
    func testRatingViewModelCallsViewModelForCell() {
        viewModel.fetchUsers()
        let userIndex = Int.random(in: 0..<statisticProviderSpy.mockUsers.count)
        let user = statisticProviderSpy.mockUsers[userIndex]
        viewModel.didSelectUser(at: userIndex)
        let cellViewModel = viewModel.viewModelForCell(at: userIndex)
        XCTAssertEqual(cellViewModel.positionInRating, user.rating)
    }
    
    func testRatingViewModelCallsViewModelForUserCard() {
        viewModel.fetchUsers()
        let userIndex = Int.random(in: 0..<statisticProviderSpy.mockUsers.count)
        let user = statisticProviderSpy.mockUsers[userIndex]
        let userCard = viewModel.viewModelForUserCard(at: userIndex)
        XCTAssertEqual(userCard, user)
    }
}
