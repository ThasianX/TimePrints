import Foundation

extension Bool {
    func when<T>(true t: @autoclosure () -> T, false f: @autoclosure () -> T) -> T {
        if self {
            return t()
        } else {
            return f()
        }
    }
}
