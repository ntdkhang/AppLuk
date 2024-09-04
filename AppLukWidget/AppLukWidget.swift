//
//  AppLukWidget.swift
//  AppLukWidget
//
//  Created by Khang Nguyen on 8/31/24.
//

import FirebaseAuth
import FirebaseFirestore
import SwiftUI
import WidgetKit

struct Provider: AppIntentTimelineProvider {
    func placeholder(in _: Context) -> KnowledgeEntry {
        KnowledgeEntry(date: .now, knowledge: Knowledge(postedById: "", title: "", contentPages: [], imageUrls: []))
    }

    func snapshot(for _: ConfigurationAppIntent, in _: Context) async -> KnowledgeEntry {
        KnowledgeEntry(date: .now, knowledge: Knowledge(postedById: "", title: "", contentPages: [], imageUrls: []))
    }

    func timeline(for _: ConfigurationAppIntent, in _: Context) async -> Timeline<KnowledgeEntry> {
        var entries: [KnowledgeEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!

        let imageUrl = "https://firebasestorage.googleapis.com:443/v0/b/blessed-by-knowledge-33707.appspot.com/o/knowledge_images%2Fu7qvNbXhU4cCCuUfY0fe0?alt=media&token=57339dac-df39-45fc-a91a-f07acfd8ff55"
        let knowledge = Knowledge(postedById: "", title: Auth.auth().currentUser?.uid ?? "nil", contentPages: [
            "\(Auth.auth().currentUser?.uid ?? "nil")"], imageUrls:
        [imageUrl])

        let entry = KnowledgeEntry(date: currentDate, knowledge: knowledge)
        entries.append(entry)

//        fetchKnowledge { knowledge in
//            let entry = KnowledgeEntry(date: currentDate, knowledge: knowledge)
//
//            entries.append(entry)
//        }

        return Timeline(entries: entries, policy: .after(nextUpdate))
    }

//    func fetchKnowledge(completion: @escaping (Knowledge) -> Void) {
//        Firestore.firestore().collection("knowledges")
//            .whereField("postedById", in: ["0KBb2kjXOkVQtpxUjkXg2Ss4aZA2"])
//            .order(by: "timePosted", descending: true)
//            .getDocuments(completion: { querySnapshot, error in
//                guard let documents = querySnapshot?.documents else {
//                    print("Error fetching knowledges: \(error!)")
//                    return
//                }
//                do {
//                    let knowledge = try documents.first?.data(as: Knowledge.self)
//                    completion(knowledge!)
//                } catch {
//                    print("Error reading knowledge for widget: \(error)")
//                    return
//                }
//            })
//    }
}

struct KnowledgeEntry: TimelineEntry {
    let date: Date
    let knowledge: Knowledge
}

struct AppLukWidgetEntryView: View {
    var imageUrl: String?
    var pageContent: String

    var body: some View {
        ZStack {
            clippedImage
            Color.imageBlur
            VStack {
                Text(pageContent)
                    .font(.com_regular)
                    .lineSpacing(12)
                    .lineLimit(nil)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(16)
            }
        }
        .aspectRatio(1.0, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    var clippedImage: some View {
        Color.clear
            .aspectRatio(1.0, contentMode: .fit)
            .overlay(
                Image("aussie")
                    .resizable()
                    .scaledToFill()
            )
            .clipped()
        // .clipShape(RoundedRectangle(cornerRadius: 30))
    }
}

struct AppLukWidget: Widget {
    let kind: String = "AppLukWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            AppLukWidgetEntryView(imageUrl: entry.knowledge.imageUrls.first ?? "", pageContent: entry.knowledge.contentPages.first ?? "")
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.systemLarge])
    }
}
