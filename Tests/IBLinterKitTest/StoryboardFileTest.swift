import XCTest
import IBDecodable

class StoryboardFileTest: XCTestCase {

    func testStoryboardFile() {
        let url = self.url(forResource: "ViewControllerTest", withExtension: "storyboard")
        let storyboardFile = try! StoryboardFile.init(url: url)
        XCTAssertEqual(storyboardFile.fileName, "ViewControllerTest.storyboard")
    }
}
