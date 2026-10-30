import XCTest
@testable import PlantCareApp

final class ModelsTests: XCTestCase {

    //Test the Plant Model-test adding plant details 
    func testPlantModelInitialization() {
        let plant = Plant(
            name: "Monstera",
            botanicalName: "Monstera deliciosa",
            location: "Living Room",
            health: .healthy,
            imageName: "leaf.fill"
        )
        
        XCTAssertEqual(plant.name, "Monstera")
        XCTAssertEqual(plant.botanicalName, "Monstera deliciosa")
        XCTAssertEqual(plant.location, "Living Room")
        XCTAssertEqual(plant.health, .healthy)
    }

    //Test the GrowthEntry Model (used in the Growth Charts)// chek whether chart works
    func testGrowthEntryModel() {
        let testDate = Date()
        let entry = GrowthEntry(date: testDate, height: 25.5, leaves: 4)
        
        XCTAssertEqual(entry.date, testDate)
        XCTAssertEqual(entry.height, 25.5)
        XCTAssertEqual(entry.leaves, 4)
    }

    //Test the PlantHealth Raw Values (Crucial for Firebase Firestore)
    func testPlantHealthRawValues() {
        // If these fail, Firebase won't be able to read/write the health status properly
        XCTAssertEqual(PlantHealth.healthy.rawValue, "Health")
        XCTAssertEqual(PlantHealth.needsCare.rawValue, "Needs care")
    }

    //Test the CareSchedule Defaults
    func testCareScheduleDefaults() {
        let schedule = CareSchedule()
        
        // Default watering should be every 5 days
        XCTAssertEqual(schedule.waterEveryDays, 5)
        
        // Default fertilizing should be every 14 days
        XCTAssertEqual(schedule.fertilizeEveryDays, 14)
    }

    //Test the CareKind Enums (Watering vs Fertilizer)
    func testCareKindTitles() {
        XCTAssertEqual(CareKind.watering.title, "Watering")
        XCTAssertEqual(CareKind.fertilizer.title, "Fertilizer")
        
        XCTAssertEqual(CareKind.watering.icon, "drop.fill")
        XCTAssertEqual(CareKind.fertilizer.icon, "sparkles")
    }
}