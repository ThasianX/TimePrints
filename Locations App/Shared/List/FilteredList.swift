// Kevin Li - 11:43 PM - 3/8/20

import CoreData
import SwiftUI

struct FilteredList<T: NSManagedObject, Content: View>: View {
    var fetchRequest: FetchRequest<T>
    var singers: FetchedResults<T> { fetchRequest.wrappedValue }

    let spacing: CGFloat
    // this is our content closure; we'll call this once for each item in the list
    let content: (T) -> Content

    var body: some View {
        VStack(spacing: spacing) {
            ForEach(fetchRequest.wrappedValue, id: \.self) { singer in
                self.content(singer)
            }
        }
    }

    init(predicate: NSPredicate, sortDescriptors: [NSSortDescriptor] = [], spacing: CGFloat, @ViewBuilder content: @escaping (T) -> Content) {
        fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: sortDescriptors, predicate: predicate)
        self.spacing = spacing
        self.content = content
    }
}
