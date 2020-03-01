// Kevin Li - 4:25 PM - 2/23/20

import SwiftUI

struct LocationsListView: View {
    @FetchRequest(entity: Location.entity(), sortDescriptors: []) var visits: FetchedResults<Location>

    var body: some View {
        EmptyView()
    }
}

struct LocationsListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsListView()
    }
}
