

import Foundation
import SwiftyJSON

public struct Feed {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let newGameList = "results"
    static let icon = "icon"
    static let title = "title"
  }

  // MARK: Properties
  public var newGameList: [NewGameList]?
  public var icon: String?
   public var title: String?

  // MARK: SwiftyJSON Initializers
  /// Initiates the instance based on the object.
  ///
  /// - parameter object: The object of either Dictionary or Array kind that was passed.
  /// - returns: An initialized instance of the class.
  public init(object: Any) {
    self.init(json: JSON(object))
  }

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public init(json: JSON) {
    if let items = json[SerializationKeys.newGameList].array { newGameList = items.map { NewGameList(json: $0) } }
    icon = json[SerializationKeys.icon].string
    title = json[SerializationKeys.title].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = newGameList { dictionary[SerializationKeys.newGameList] = value.map { $0.dictionaryRepresentation() } }
    if let value = icon { dictionary[SerializationKeys.icon] = value }
    if let value = title { dictionary[SerializationKeys.title] = value }
    return dictionary
  }

}
