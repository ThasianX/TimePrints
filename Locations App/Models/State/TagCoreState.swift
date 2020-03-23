import Combine
import SwiftUI

class TagCoreState: ObservableObject {
    @Published var operation: Operation = .init()
    @Published var alert: TransientAlert = .init()

    var anyCancellable = Set<AnyCancellable>()

    init() {
        operation.objectWillChange.sink { _ in
            self.objectWillChange.send()
        }.store(in: &anyCancellable)
        
        alert.objectWillChange.sink { _ in
            self.objectWillChange.send()
        }.store(in: &anyCancellable)
    }

    var isShowingAddOrEdit: Bool {
        operation.add || operation.edit
    }

    var isntShowingAddNorEdit: Bool {
        !operation.add && !operation.edit
    }

    func addNewTag() {
        UIApplication.shared.endEditing(true)
        if isNameCompliable() {
            operation.addNewTag()
        }
    }

    func editTag() {
        UIApplication.shared.endEditing(true)
        if isNameCompliable() {
            operation.editTag()
        }
    }

    func isNameCompliable() -> Bool {
        let name = operation.nameInput.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !name.isEmpty else {
            alert.setMessage("Name cannot be empty")
            return false
        }

        guard !Tag.containsTag(with: name, color: operation.selectedColor) else {
            alert.setMessage("Tag already exists")
            return false
        }

        return true
    }

    func removeTag(_ tag: Tag) {
        if tag.isDefault {
            alert.setMessage("Default tag cannot be deleted")
        } else {
            let deletedTag = DeletedTag(name: tag.name, color: tag.color, locations: tag.locations)
            alert.setRemoval(deletedTag)
            tag.delete()
            setTagForAffectedLocationsToDefault(locations: deletedTag.locations)
        }
    }

    private func setTagForAffectedLocationsToDefault(locations: Set<Location>) {
        locations.forEach { $0.setTag(tag: .default) }
    }

    func revertDeletion() {
        let tag = Tag.create(name: alert.deletedTag.name, hex: alert.deletedTag.color)
        revertTagForAffectedLocations(to: tag)
        alert.stop()
    }

    private func revertTagForAffectedLocations(to tag: Tag) {
        alert.deletedTag.locations.forEach { $0.setTag(tag: tag) }
    }
}

extension TagCoreState {
    class Operation: ObservableObject {
        @Published var add: Bool = false
        @Published var edit: Bool = false
        @Published var nameInput: String = ""
        @Published var selectedColorIndex: Int = 0
        @Published var tag: Tag? = nil

        var selectedColor: UIColor {
            AppColors.tags[AppColors.identifiers[selectedColorIndex]]!
        }

        func beginAdd() {
            add = true
        }

        @discardableResult
        func addNewTag() -> Tag {
            let tag = Tag.create(name: nameInput.trimmingCharacters(in: .whitespacesAndNewlines), color: selectedColor)
            resetAdd()
            return tag
        }

        func resetAdd() {
            add = false
            reset()
        }

        func beginEdit() {
            edit = true
        }

        func editTag() {
            tag!.edit(name: nameInput, color: selectedColor)
            resetEdit()
        }

        func resetEdit() {
            edit = false
            reset()
        }

        func setTagToEdit(_ tag: Tag) {
            self.tag = tag
            nameInput = tag.name
            let identifier = AppColors.tags.key(for: tag.uiColor)!
            selectedColorIndex = AppColors.identifiers.firstIndex(of: identifier)!
            edit = true
        }

        func reset() {
            UIApplication.shared.endEditing(true)
            tag = nil
            nameInput = ""
            selectedColorIndex = 0
        }
    }

    class TransientAlert: ObservableObject {
        @Published private var workItem: DispatchWorkItem = .init(block: {})
        @Published private var state: AlertState = .inactive

        enum AlertState: Equatable {
            case inactive
            case message(String)
            case removal(DeletedTag)
        }

        var isInactive: Bool {
            state == .inactive
        }

        var isMessage: Bool {
            if case .message(_) = state {
                return true
            }
            return false
        }

        var isRemoval: Bool {
            if case .removal(_) = state {
                return true
            }
            return false
        }

        var message: String {
            let alertMessage: String
            switch state {
            case .message(let message):
                alertMessage = message
            default:
                alertMessage = ""
            }
            return alertMessage
        }

        var deletedTag: DeletedTag {
            let deletedTag: DeletedTag
            switch state {
            case .removal(let tag):
                deletedTag = tag
            default:
                fatalError("Should not be accessing this when state isn't removal")
            }
            return deletedTag
        }

        func setMessage(_ message: String) {
            state = .message(message)
            start()
        }

        func setRemoval(_ tag: DeletedTag) {
            state = .removal(tag)
            start()
        }

        private func start() {
            workItem.cancel()
            workItem = DispatchWorkItem(block: stop)
            DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: workItem)
        }

        func stop() {
            state = .inactive
        }
    }

    struct DeletedTag: Equatable {
        let name: String
        let color: String
        let locations: Set<Location>

        var uiColor: UIColor {
            UIColor(color)
        }
    }
}
