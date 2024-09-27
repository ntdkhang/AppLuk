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
        KnowledgeEntry(date: .now, knowledge: WidgetKnowledge(postedById: "", title: "", contentPages: [], imageUrls: []))
    }

    func snapshot(for _: ConfigurationAppIntent, in _: Context) async -> KnowledgeEntry {
        KnowledgeEntry(date: .now, knowledge: WidgetKnowledge(postedById: "", title: "", contentPages: [], imageUrls: []))
    }

    func timeline(for _: ConfigurationAppIntent, in _: Context) async -> Timeline<KnowledgeEntry> {
        var entries: [KnowledgeEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
        let friendsId = await fetchFriendsId(userId: Auth.auth().currentUser?.uid)
        let knowledge = await fetchKnowledge(friendsId: friendsId)
        var uiImage: UIImage? = nil
        if let urlString = knowledge?.imageUrls.first ?? nil {
            uiImage = await downloadImage(from: urlString)
        }

        let entry = KnowledgeEntry(date: currentDate, knowledge: knowledge, uiImage: uiImage)
        entries.append(entry)

        return Timeline(entries: entries, policy: .after(nextUpdate))
    }

    func downloadImage(from urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            print("Error downloading Image for widget: \(error)")
            return nil
        }
    }

    func fetchKnowledge(friendsId: [String]) async -> WidgetKnowledge? {
        do {
            if friendsId.isEmpty { return nil }
            let querySnapshot = try await Firestore.firestore().collection("knowledges")
                .whereField("postedById", in: friendsId)
                .order(by: "timePosted", descending: true)
                .getDocuments()

            guard let document = querySnapshot.documents.first else { return nil }
            let knowledge = try document.data(as: WidgetKnowledge.self)
            return knowledge
        } catch {
            print("Error reading knowledge for widget: \(error)")
            return nil
        }
    }

    func fetchFriendsId(userId: String?) async -> [String] {
        guard let userId = userId else { return [] }
        let docRef = Firestore.firestore().collection("users").document(userId)
        do {
            let user = try await docRef.getDocument(as: WidgetUser.self)
            return user.friendsId
        } catch {
            print("Error reading user for widget: \(error)")
            return []
        }
    }
}

struct KnowledgeEntry: TimelineEntry {
    var date: Date
    var knowledge: WidgetKnowledge?
    var uiImage: UIImage?
}

struct AppLukWidgetEntryView: View {
    var knowledge: WidgetKnowledge?
    var uiImage: UIImage?

    var body: some View {
        VStack {
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

            Text(knowledge?.title ?? "")
                .font(.com_regular)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    var pageContent: String {
        if let knowledge = knowledge, let content = knowledge.contentPages.first {
            return content
        }

        return ""
    }

    var clippedImage: some View {
        Color.clear
            .aspectRatio(1.0, contentMode: .fit)
            .overlay(
                backgroundImage
            )
            .clipped()
        // .clipShape(RoundedRectangle(cornerRadius: 30))
    }

    @ViewBuilder
    var backgroundImage: some View {
        if let uiImage = uiImage {
            Image(uiImage: uiImage.resized())
                .resizable()
                .scaledToFill()
        } else {
            Color.gray
        }
    }
}

struct AppLukWidget: Widget {
    let kind: String = "AppLukWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            AppLukWidgetEntryView(knowledge: entry.knowledge, uiImage: entry.uiImage)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.systemLarge])
    }
}
