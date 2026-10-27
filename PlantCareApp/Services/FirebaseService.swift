import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirebaseService {
    static let shared = FirebaseService()
    private let db = Firestore.firestore()
    
    func savePlant(name: String, botanicalName: String, location: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let newPlant = Plant(
            name: name,
            botanicalName: botanicalName,
            location: location,
            health: .healthy,
            imageName: "leaf.fill"
        )
        
        do {
            try db.collection("users").document(userId).collection("plants").addDocument(from: newPlant)
        } catch {
            print("Error saving plant: \(error.localizedDescription)")
        }
    }
    
    func fetchPlants(completion: @escaping ([Plant]) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(userId).collection("plants").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching: \(error.localizedDescription)")
                completion([])
                return
            }
            
            let plants = snapshot?.documents.compactMap {
                try? $0.data(as: Plant.self)
            } ?? []
            
            completion(plants)
        }
    }
}
