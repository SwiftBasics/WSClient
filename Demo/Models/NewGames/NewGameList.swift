

import Foundation
import SwiftyJSON

public struct NewGameList {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let copyright = "copyright"
    static let kind = "kind"
    static let name = "name"
    static let artworkUrl100 = "artworkUrl100"
    static let id = "id"
    static let genres = "genres"
    static let artistId = "artistId"
    static let releaseDate = "releaseDate"
    static let artistUrl = "artistUrl"
    static let contentAdvisoryRating = "contentAdvisoryRating"
    static let url = "url"
    static let artistName = "artistName"
  }

  // MARK: Properties
  public var copyright: String?
  public var kind: String?
  public var name: String?
  public var artworkUrl100: String?
  public var id: String?
  public var genres: [Genres]?
  public var artistId: String?
  public var releaseDate: String?
  public var artistUrl: String?
  public var contentAdvisoryRating: String?
  public var url: String?
  public var artistName: String?

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
    copyright = json[SerializationKeys.copyright].string
    kind = json[SerializationKeys.kind].string
    name = json[SerializationKeys.name].string
    artworkUrl100 = json[SerializationKeys.artworkUrl100].string
    id = json[SerializationKeys.id].string
    if let items = json[SerializationKeys.genres].array { genres = items.map { Genres(json: $0) } }
    artistId = json[SerializationKeys.artistId].string
    releaseDate = json[SerializationKeys.releaseDate].string
    artistUrl = json[SerializationKeys.artistUrl].string
    contentAdvisoryRating = json[SerializationKeys.contentAdvisoryRating].string
    url = json[SerializationKeys.url].string
    artistName = json[SerializationKeys.artistName].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = copyright { dictionary[SerializationKeys.copyright] = value }
    if let value = kind { dictionary[SerializationKeys.kind] = value }
    if let value = name { dictionary[SerializationKeys.name] = value }
    if let value = artworkUrl100 { dictionary[SerializationKeys.artworkUrl100] = value }
    if let value = id { dictionary[SerializationKeys.id] = value }
    if let value = genres { dictionary[SerializationKeys.genres] = value.map { $0.dictionaryRepresentation() } }
    if let value = artistId { dictionary[SerializationKeys.artistId] = value }
    if let value = releaseDate { dictionary[SerializationKeys.releaseDate] = value }
    if let value = artistUrl { dictionary[SerializationKeys.artistUrl] = value }
    if let value = contentAdvisoryRating { dictionary[SerializationKeys.contentAdvisoryRating] = value }
    if let value = url { dictionary[SerializationKeys.url] = value }
    if let value = artistName { dictionary[SerializationKeys.artistName] = value }
    return dictionary
  }

}
