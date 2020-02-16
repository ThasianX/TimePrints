import SwiftUI

struct VisitDetailsView: View {
    @State private var mapFull = false
    @State private var isFavorite = false
    @Binding var selectedIndex: Int

    let index: Int
    let visit: Visit
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                header
                    .padding(.bottom, isSelected ? 20 : 0)
                visitDurationText
                fullMonthWithDayOfWeekTextIfSelected
                    .padding(.bottom, isSelected ? 10 : 0)
                locationTagView
                Group {
                    if isSelected {
                        staticMapView
                        locationAddressText
                    }
                }
                Spacer()
            }
            .padding(.top, isSelected ? 80 : 12)
            .padding(.leading, isSelected ? 30 : 40)
            .padding(.trailing, isSelected ? 30 : 40)
            .frame(height: VisitCellConstants.height(if: isSelected))
            .frame(maxWidth: VisitCellConstants.maxWidth(if: isSelected))
            .background(Color(UIColor.salmon))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .onTapGesture(perform: setSelectedVisitIndex)
        }
        .frame(height: VisitCellConstants.height(if: isSelected))
        .animation(.spring())
        .onAppear(perform: setFavoriteState)
    }
}

private extension VisitDetailsView {
    var header: some View {
        HStack {
            backButton
                .fade(!isSelected)
            Spacer()
            HStack {
                locationNameText
                starImageIfNotSelectedAndIsFavorite
            }
            Spacer()
            favoriteButton
                .fade(!isSelected)
        }
    }

    private var backButton: some View {
        BImage(perform: unselectRow, image: .init(systemName: "arrow.left"))
    }

    private var locationNameText: some View {
        Text(visit.location.name)
            .font(isSelected.when(true: .system(size: 22), false: .headline))
            .fontWeight(isSelected.when(true: .bold, false: .regular))
            .lineLimit(isSelected.when(true: nil, false: 1))
            .multilineTextAlignment(.center)
            .animation(nil)
    }

    private var starImageIfNotSelectedAndIsFavorite: some View {
        Group {
            if !isSelected && isFavorite {
                Image("star.fill")
                    .foregroundColor(.yellow)
            }
        }
    }

    private var favoriteButton: some View {
        BImage(perform: favorite, image: favoriteImage)
            .foregroundColor(.yellow)
    }

    private var favoriteImage: Image {
        if isFavorite {
            return Image("star.fill")
        } else {
            return Image("star")
        }
    }
}

extension VisitDetailsView {
    private var visitDurationText: some View {
        Text(visit.visitDuration)
            .font(isSelected ? .system(size: 18) : .system(size: 10))
            .tracking(isSelected ? 2 : 0)
            .animation(nil)
    }

    private var fullMonthWithDayOfWeekTextIfSelected: some View {
        Group {
            if isSelected {
                fullMonthWithDayOfWeekText
            }
        }
    }

    private var locationTagView: some View {
        TagView(tag: visit.location.tag, displayName: isSelected)
            .padding(.init(top: 6, leading: 0, bottom: 4, trailing: 0))
    }
}

private extension VisitDetailsView {
    private var fullMonthWithDayOfWeekText: some View {
        Text(visit.arrivalDate.fullMonthWithDayOfWeek.uppercased()).font(.caption)
    }

    private var staticMapView: some View {
        StaticMapView(coordinate: visit.location.coordinate, name: visit.location.name, color: .blue)
            .frame(width: mapFull ? screen.width : screen.width / 2.5, height: mapFull ? screen.height * 3 / 4 : screen.width / 2.5)
            .cornerRadius(mapFull ? 0 : screen.width / 5)
            .onTapGesture(perform: toggleMapState)
            .animation(.spring())
    }

    private var locationAddressText: some View {
        Text(visit.location.address.uppercased())
            .font(.headline)
            .multilineTextAlignment(.center)
    }
}

extension VisitDetailsView {
    private func setFavoriteState() {
        isFavorite = visit.isFavorite
    }

    private func setSelectedVisitIndex() {
        withAnimation {
            self.selectedIndex = index
        }
    }

    private var isSelected: Bool {
        selectedIndex == index
    }
    
    private func unselectRow() {
        withAnimation {
            self.selectedIndex = -1
        }
    }
    
    private func favorite() {
        withAnimation {
            isFavorite = visit.favorite()
        }
    }

    private func toggleMapState() {
        withAnimation {
            mapFull.toggle()
        }
    }
}

struct VisitDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VisitDetailsView(selectedIndex: .constant(1), index: -1, visit: .preview).previewLayout(.sizeThatFits)
            
            VisitDetailsView(selectedIndex: .constant(1), index: 1, visit: .preview)
        }
        
    }
}
