// Kevin Li - 1:27 PM - 2/23/20

import SwiftUI

struct TagsListView: View {
    @FetchRequest(entity: Tag.entity(), sortDescriptors: []) var visits: FetchedResults<Tag>

    var body: some View {
        EmptyView()
    }
}

struct TagsListView_Previews: PreviewProvider {
    static var previews: some View {
        TagsListView()
    }
}
