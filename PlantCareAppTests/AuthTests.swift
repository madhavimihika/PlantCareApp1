import XCTest
@testable import PlantCareApp

final class AuthTests: XCTestCase {

    func testAuthServiceSingleton() {
        // Test that the AuthService is shared and not nil
        let service = AuthService.shared
        XCTAssertNotNil(service)
    }
    
    func testEmptyEmailSignIn() async {
        // Attempting to sign in with an empty email should throw an error
        do {
            _ = try await AuthService.shared.signIn(email: "", password: "password123")
            XCTFail("Sign in should have failed with an empty email")
        } catch {
            // Success: We expected an error
            XCTAssertNotNil(error)
        }
    }
    
    func testEmptyPasswordSignIn() async {
        // Attempting to sign in with an empty password should throw an error
        do {
            _ = try await AuthService.shared.signIn(email: "test@test.com", password: "")
            XCTFail("Sign in should have failed with an empty password")
        } catch {
            // Success: We expected an error
            XCTAssertNotNil(error)
        }
    }
}