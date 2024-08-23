//
//  KnowledgesViewModel.swift
//  AppLuk
//
//  Created by Khang Nguyen on 8/19/24.
//

import FirebaseFirestore
import Foundation

class KnowledgesViewModel: ObservableObject {
    // @Published var knowledges = [Knowledge]()
    //
    // func getKnowledges() {
    //     let db = Firestore.firestore()
    //     db.collection("knowledges").whereField("postedById", in: DataStorageManager.shared.friendsAndSelfId)
    //         .addSnapshotListener { querySnapshot, error in
    //             guard let documents = querySnapshot?.documents else {
    //                 print("Error fetching knowledges: \(error!)")
    //                 return
    //             }
    //
    //             let knowledges = documents.compactMap { document in
    //                 do {
    //                     let knowledge = try document.data(as: Knowledge.self)
    //                     return knowledge
    //                 } catch {
    //                     print(error)
    //                     return nil
    //                 }
    //             }
    //
    //             self.knowledges = knowledges
    //         }
    // }
}
