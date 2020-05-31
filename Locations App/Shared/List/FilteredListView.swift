// Kevin Li - 9:30 PM - 5/30/20

import CoreData
import SwiftUI

struct FilteredListView<T: NSManagedObject, Content: View>: View where T: Identifiable {
    private let fetchRequest: FetchRequest<T>
    private let content: (T) -> Content

    init(sortDescriptors: [NSSortDescriptor] = [],
         predicate: NSPredicate,
         @ViewBuilder content: @escaping (T) -> Content) {
        fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: sortDescriptors, predicate: predicate)
        self.content = content
    }

    var body: some View {
        List(fetchRequest.wrappedValue) { object in
            self.content(object)
        }
    }
}
