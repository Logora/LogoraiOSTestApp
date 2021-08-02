import UIKit

class InputProvider {
    static let sharedInstance = InputProvider()
    private var userPositions: [Int: Int] = [:]
    private var updateArgument: Message? = nil
    private var removeArgument: Message? = nil
    
    private init() {
    }
    
    func setUserPositions(debateId: Int, positionId: Int) {
        self.userPositions.add([debateId: positionId])
    }
    
    func removeUserPosition(id: Int) {
        self.userPositions.removeValue(forKey: id)
    }
    
    func getUserPositions() -> [Int: Int] {
        return self.userPositions
    }
    
    func setUpdateArgument(argument: Message) {
        self.updateArgument = argument
    }
    
    func getUpdateArgument() -> Message? {
        return self.updateArgument != nil ? self.updateArgument : nil
    }
    
    func removeUpdateArgument() {
        self.removeArgument = nil
    }
    
    func setRemoveArgument(argument: Message) {
        self.removeArgument = argument
    }
    
    func getRemoveArgument() -> Message? {
        return self.removeArgument != nil ? self.removeArgument : nil
    }
    
    func removeRemoveArgument() {
        self.removeArgument = nil
    }
}
