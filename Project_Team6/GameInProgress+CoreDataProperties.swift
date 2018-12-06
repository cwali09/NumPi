import Foundation
import CoreData


extension GameInProgress {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<GameInProgress> {
        return NSFetchRequest<GameInProgress>(entityName: "GameInProgress")
    }
    
    @NSManaged public var gameLog: String
    @NSManaged public var gameID: String
    @NSManaged public var playerArray: String
    
}

@objc(GameInProgress)
public class GameInProgress: NSManagedObject {
    
}
