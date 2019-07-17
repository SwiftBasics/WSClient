

import Foundation
import SwiftyJSON

public struct Genres {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let name = "name"
    static let url = "url"
    static let genreId = "genreId"
  }

  // MARK: Properties
  public var name: String?
  public var url: String?
  public var genreId: String?

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
    name = json[SerializationKeys.name].string
    url = json[SerializationKeys.url].string
    genreId = json[SerializationKeys.genreId].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = url { dictionary[SerializationKeys.url] = value }
    if let value = genreId { dictionary[SerializationKeys.genreId] = value }
    return dictionary
  }

}
