//
//  EditTagView.swift
//  Locations App
//
//  Created by Kevin Li on 2/3/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import SwiftUI

struct EditTagView: View {
    @FetchRequest(
        entity: Tag.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Tag.name, ascending: true)
        ]
    ) var tags: FetchedResults<Tag>
    
    @State private var showAdd: Bool = false
    @State private var showEdit: Bool = false
    @State private var tagInput: String = ""
    @State private var selectedColorIndex: Int = 1
    @State private var tagInEditing: Tag? = nil
    @State private var presentAlert: Bool = false
    @State private var deletedTag: Tag? = nil
    @State private var alertMessage: String? = nil
    @Binding var show: Bool
    @Binding var location: Location?
    @Binding var stayAtLocation: Bool
    
    let colors = AppColors.tags
    let identifiers = AppColors.tags.ascendingKeys
    
    private var selectedColor: Color {
        Color(colors[identifiers[selectedColorIndex]]!)
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "tag.fill")
                        .foregroundColor(.white)
                        .colorMultiply((showAdd || showEdit) ? selectedColor : (location != nil ? Color(location!.accent) : .clear))
                        .animation(.easeInOut)
                    ZStack {
                        Text("CHOOSE TAG")
                            .tracking(5)
                            .font(.system(size: 20))
                            .bold()
                            .fade(showAdd || showEdit)
                        Text("MAKE TAG")
                            .tracking(5)
                            .font(.system(size: 20))
                            .bold()
                            .fade(!showAdd)
                        Text("EDIT TAG")
                            .tracking(5)
                            .font(.system(size: 20))
                            .bold()
                            .fade(!showEdit)
                    }
                    .foregroundColor(.white)
                    .animation(.easeInOut)
                    
                    Spacer()
                    
                    ZStack {
                        BImage(condition: $showAdd, image: .init(systemName: "plus"))
                            .foregroundColor(.white)
                            .fade(showAdd || showEdit)
                        HStack {
                            BImage(action: showAdd ? resetAddTag : resetEditTag, image: .init(systemName: "xmark.circle.fill"))
                                .foregroundColor(.red)
                                .animation(.easeInOut)
                            BImage(action: showAdd ? addNewTag : editTag, image: .init(systemName: "checkmark.circle.fill"))
                                .foregroundColor(.white)
                                .colorMultiply(selectedColor)
                                .animation(.easeInOut)
                        }
                        .fade(!showAdd && !showEdit)
                    }
                }
                .padding()
                .offset(y: showAdd || showEdit ? 250 : 0)
                .animation(.spring())
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        ForEach(tags) { tag in
                            ColorTextRow(text: tag.name, color: tag.uiColor, selected: self.location?.tag == tag)
                                .background(Color.clear)
                                .padding(8)
                                .onTap {
                                    self.setTag(tag: tag)
                            }
                            .contextMenu {
                                TagContextMenu(tag: tag, onEdit: self.displayEditTag, onDelete: self.deleteTag)
                                    .colorScheme(.dark)
                            }
                        }
                    }
                }
                .fade(showAdd || showEdit)
                .scaleEffect(showAdd || showEdit ? 0 : 1)
                
                VSpace(50)
                    .fade(showAdd || showEdit)
            }
            
            VStack {
                TextField("Tag Name...", text: $tagInput)
                    .padding(.init(top: 0, leading: 30, bottom: 0, trailing: 30))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.center)
                Picker(selection: $selectedColorIndex, label: Text("Please choose a color")) {
                    ForEach(0..<identifiers.count) {
                        ColorTextRow(text: self.identifiers[$0], color: self.colors[self.identifiers[$0]]!, selected: false)
                            .tag($0)
                    }
                }
                .labelsHidden()
                Spacer()
            }
            .padding()
            .fade(!showAdd && !showEdit)
            .scaleEffect(showAdd || showEdit ? 1 : 0)
            .animation(.spring())
            
            
            VStack {
                Spacer()
                HStack {
                    if deletedTag != nil {
                        Text("Deleted: \(deletedTag!.name)")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.trailing, 8)
                        
                        Button(action: revert) {
                            Text("Revert")
                                .font(.headline)
                                .foregroundColor(Color(deletedTag?.uiColor ?? .clear))
                        }
                    } else {
                        Text(alertMessage ?? "")
                            .foregroundColor(.white)
                    }
                }
                .padding()
            }
            .fade(!presentAlert)
        }
    }
    
    private func setTag(tag: Tag) {
        location!.setTag(tag: tag)
        reset()
    }
    
    private func reset() {
        resetAddTag()
        show = false
        stayAtLocation = true
    }
    
    private func resetAddTag() {
        tagInput = ""
        selectedColorIndex = 1
        showAdd = false
    }
    
    private func addNewTag() {
        let name = tagInput.trimmingCharacters(in: .whitespacesAndNewlines)
        if !name.isEmpty {
            let tag = Tag.create(name: tagInput, color: colors[identifiers[selectedColorIndex]]!)
            location!.setTag(tag: tag)
            reset()
        }
    }
    
    private func displayEditTag(tag: Tag) {
        tagInEditing = tag
        tagInput = tag.name
        let identifier = colors.key(for: tag.uiColor)!
        selectedColorIndex = identifiers.firstIndex(of: identifier)!
        showEdit = true
    }
    
    private func deleteTag(tag: Tag) {
        guard let location = location else { return }
        let defaultTag = Tag.getDefault()
        if tag == defaultTag {
            self.alertMessage = "Cannot delete default tag"
        } else {
            let deleted = tag.delete()
            if deleted == location.tag {
                location.setTag(tag: defaultTag)
            }
            self.deletedTag = tag
        }
        self.presentAlert = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.resetAlert()
        }
    }
    
    private func revert() {
        if let tag = deletedTag {
            Tag.create(from: tag)
            resetAlert()
        }
    }
    
    private func resetAlert() {
        self.presentAlert = false
        self.alertMessage = nil
        self.deletedTag = nil
    }
    
    private func resetEditTag() {
        tagInEditing = nil
        tagInput = ""
        selectedColorIndex = 1
        showEdit = false
    }
    
    private func editTag() {
        let name = tagInput.trimmingCharacters(in: .whitespacesAndNewlines)
        if !name.isEmpty {
            tagInEditing!.edit(name: tagInput, color: colors[identifiers[selectedColorIndex]]!)
            resetEditTag()
        }
    }
}

struct ColorTextRow: View {
    let text: String
    let color: UIColor
    let selected: Bool
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color(color))
                .frame(width: 20, height: 20)
            Text(text)
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(nil)
            Spacer()
            if selected {
                Image(systemName: "checkmark")
                    .foregroundColor(.white)
            }
        }
        .padding(.init(top: 0, leading: 32, bottom: 0, trailing: 0))
    }
}

struct EditTagView_Previews: PreviewProvider {
    static var previews: some View {
        return EditTagView(show: .constant(true), location: .constant(.preview), stayAtLocation: .constant(false)).environment(\.managedObjectContext, CoreData.stack.context).background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
