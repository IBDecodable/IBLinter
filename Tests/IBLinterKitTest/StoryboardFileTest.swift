import XCTest
import IBLinterCore

class StoryboardFileTest: XCTestCase {

    func testStoryboardFile() {
        let url = "Tests/IBLinterKitTest/Resources/ViewControllerTest.storyboard"
        let storyboardFile = StoryboardFile.init(path: url)
        XCTAssertEqual(storyboardFile.fileName, "ViewControllerTest.storyboard")
    }
}
