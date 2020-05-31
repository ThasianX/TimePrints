// Kevin Li - 11:43 PM - 3/8/20

import CoreData
import SwiftUI

struct FilteredSearchView<T: NSManagedObject, Content: View>: View where T: Identifiable {
    @State private var query = ""

    let sortDescriptors: [NSSortDescriptor]
    let predicate: NSPredicate?
    let searchKey: String

    let placeholder: String
    let searchColor: Color

    let content: (T) -> Content

    var body: some View {
        VStack {
            searchView
            filteredListView
                .resignKeyboardOnDrag()
                .padding(.bottom, 25)
        }
        .animation(.easeInOut)
    }

    init(sortDescriptors: [NSSortDescriptor] = [],
         predicate: NSPredicate? = nil,
         searchKey: String,
         placeholder: String,
         searchColor: Color,
         @ViewBuilder content: @escaping (T) -> Content) {
        self.sortDescriptors = sortDescriptors
        self.predicate = predicate
        self.searchKey = searchKey
        self.placeholder = placeholder
        self.searchColor = searchColor
        self.content = content
    }
}

private extension FilteredSearchView {
    var searchView: some View {
        SearchBarView(
            query: $query,
            placeholder: placeholder,
            color: searchColor)
    }
}

private extension FilteredSearchView {
    var filteredListView: some View {
        FilteredListView(
            sortDescriptors: sortDescriptors,
            predicate: filterPredicate,
            content: content)
    }

    var filterPredicate: NSCompoundPredicate {
        NSCompoundPredicate(
            andPredicateWithSubpredicates: [predicate, queryPredicate].compactMap{ $0 })
    }

    var queryPredicate: NSPredicate? {
        // case and diacritic insensitive predicate
        query.isEmpty ? nil : NSPredicate(format: "\(searchKey) CONTAINS[cd] %@", query)
    }
}
