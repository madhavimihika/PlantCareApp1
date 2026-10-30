import XCTest
@testable import PlantCareApp

final class GrowthTests: XCTestCase {
    
    var viewModel: MyPlantsViewModel!
    var testPlant: Plant!

    override func setUp() {
        super.setUp()
        viewModel = MyPlantsViewModel.shared
        viewModel.growthData = [:] // Clear previous data
        testPlant = Plant(name: "Test Plant", botanicalName: "", location: "", health: .healthy, imageName: "")
    }

    func testAddGrowthEntry() {
        // Add a measurement
        viewModel.addGrowth(height: 15.5, leaves: 4, for: testPlant)
        
        let entries = viewModel.growthEntries(for: testPlant)
        XCTAssertEqual(entries.count, 1)
        XCTAssertEqual(entries.first?.height, 15.5)
        XCTAssertEqual(entries.first?.leaves, 4)
    }
    
    func testGrowthEntriesSorting() {
        // Add multiple measurements
        viewModel.addGrowth(height: 10.0, leaves: 2, for: testPlant)
        viewModel.addGrowth(height: 20.0, leaves: 5, for: testPlant)
        
        let entries = viewModel.growthEntries(for: testPlant)
        XCTAssertEqual(entries.count, 2)
        
        // Ensure they are sorted by date (oldest first)
        XCTAssertLessThanOrEqual(entries[0].date, entries[1].date)
    }
    
    func testDeleteGrowthEntry() {
        viewModel.addGrowth(height: 10.0, leaves: 2, for: testPlant)
        let entries = viewModel.growthEntries(for: testPlant)
        
        // Delete it
        viewModel.deleteGrowth(entries.first!, for: testPlant)
        
        // Should be empty now
        XCTAssertEqual(viewModel.growthEntries(for: testPlant).count, 0)
    }
}