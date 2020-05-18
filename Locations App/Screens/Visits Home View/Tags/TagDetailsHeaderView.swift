// Kevin Li - 5:46 PM - 5/16/20

import SwiftUI

struct TagDetailsHeaderView: View {
    let tag: Tag
    let isSelected: Bool
    let navigateBack: () -> Void

    var body: some View {
        tagDetailsHeaderView
    }

    private var tagDetailsHeaderView: some View {
        HStack {
            if isSelected {
                Group {
                    backButton
                    Spacer()
                }
                .transition(.scale)
            }

            tagDetailsStack
            Spacer()
            numberOfFavoritedVisitsView
        }
    }
}

private extension TagDetailsHeaderView {
    private var backButton: some View {
        BImage(perform: navigateBack, image: Image(systemName: "arrow.left"))
    }

    private var tagDetailsStack: some View {
        VStack(alignment: .leading) {
            tagNameText
            numberOfLocationsText
            numberOfVisitsText
        }
        .animation(nil)
    }

    private var tagNameText: some View {
        Text(tag.name)
            .font(.headline)
            .foregroundColor(.white)
    }

    private var numberOfLocationsText: some View {
        Text("\(numberOfLocations) locations")
            .font(.caption)
            .foregroundColor(.white)
    }

    private var numberOfLocations: Int {
        tag.locations.count
    }

    private var numberOfVisitsText: some View {
        Text("\(numberOfVisits) visits")
            .font(.caption)
            .foregroundColor(.white)
    }

    private var numberOfVisits: Int {
        tag.locations.reduce(0, { count, location in
            count + location.visits.count
        })
    }
}

private extension TagDetailsHeaderView {
    private var numberOfFavoritedVisitsView: some View {
        ZStack {
            starImage
                .padding(8)
                .foregroundColor(.yellow)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 1)
                )

            numberOfFavoritedVisitsText
                .padding(6)
                .background(Color.black)
                .clipShape(Circle())
                .foregroundColor(.white)
                .offset(x: 12, y: -16)
        }
    }

    private var starImage: some View {
        Group {
            if numberOfFavoritedVisits == 0 {
                Image(systemName: "star")
                    .resizable()
                    .frame(width: 20, height: 20)
            } else {
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
        }
    }

    private var numberOfFavoritedVisitsText: some View {
        Text("\(numberOfFavoritedVisits)")
            .font(.system(size: 9))
            .foregroundColor(.white)
    }

    private var numberOfFavoritedVisits: Int {
        tag.locations.reduce(0, { favoritedVisits, location in
            favoritedVisits + location.visits.reduce(0, { favorited, visit in
                favorited + (visit.isFavorite ? 1 : 0)
            })
        })
    }
}
