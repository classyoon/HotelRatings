//
//  HotelListView.swift
//  HotelRatings
//
//  Created by Conner Yoon on 5/7/24.
//

import SwiftUI
import SwiftData

@Model
class Hotel {
    var name = "Hotel"
    var rating = 0
    init(_ name: String = "Hotel", rating: Int = 0) {
        self.name = name
        self.rating = rating
    }
}
struct HotelDetailView : View {
    @Bindable var hotel : Hotel
    var body: some View {
        TextField("Hotel", text: $hotel.name)
            .textFieldStyle(.roundedBorder)
    }
}
struct HotelListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var hotels: [Hotel]
    var body: some View {
        NavigationStack {
            List {
                ForEach(hotels){hotel in
                    HotelDetailView(hotel: hotel)
                }
            }
        }
    }
    private func addItem() {
        withAnimation {
            let newItem = Hotel("Nowhere")
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(hotels[index])
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Hotel.self, configurations: config)
    container.mainContext.insert(Hotel("Paris"))
    container.mainContext.insert(Hotel("Tokyo"))
    return HotelListView()
        .modelContainer(container)
}
