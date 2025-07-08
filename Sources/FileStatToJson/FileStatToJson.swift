import struct Foundation.Data
import struct Foundation.Date
import struct Foundation.FileAttributeKey
import class Foundation.FileManager
import class Foundation.JSONEncoder
import class Foundation.NSNumber
import class Foundation.NSString

public enum FstatToJsonErr: Error {
  case invalidArgument
  case fatalErr(String)
}

public struct BasicFileInfo: Codable {
  public let filepath: String
  public let size: Int64
  public let modified: Date
  public let fileType: String

  public static func dict2modified(_ dict: [FileAttributeKey: Any]) -> Date? {
    dict[.modificationDate] as? Date
  }

  public static func dict2fileSize(_ dict: [FileAttributeKey: Any]) -> Int64? {
    let onum: NSNumber? = dict[.size] as? NSNumber
    return onum.map { Int64(truncating: $0) }
  }

  public static func dict2fileType(_ dict: [FileAttributeKey: Any]) -> String? {
    let ons: NSString? = dict[.type] as? NSString
    return ons.flatMap { String($0) }
  }

  public static func fromFilepath(
    _ filepath: String, manager: FileManager = .default,
  ) -> Result<Self, Error> {
    let rdicts: Result<[FileAttributeKey: Any], _> = filepath2attributes(
      filepath,
      manager: manager,
    )

    return rdicts.flatMap {
      let dict: [FileAttributeKey: Any] = $0

      let odate: Date? = Self.dict2modified(dict)
      let osize: Int64? = Self.dict2fileSize(dict)
      let otype: String? = Self.dict2fileType(dict)

      guard let date = odate, let size = osize, let type = otype else {
        return .failure(FstatToJsonErr.invalidArgument)
      }

      return .success(
        Self(
          filepath: filepath,
          size: size,
          modified: date,
          fileType: type,
        ))
    }
  }

  public func toJSONData(
    encoder: JSONEncoder = JSONEncoder(),
  ) -> Result<Data, Error> {
    Result(catching: { try encoder.encode(self) })
  }

  public func toJSONString(
    encoder: JSONEncoder = JSONEncoder(),
  ) -> Result<String, Error> {
    let rdat: Result<Data, _> = self.toJSONData(encoder: encoder)
    return rdat.flatMap {
      let dat: Data = $0
      let ostr: String? = String(data: dat, encoding: .utf8)
      guard let s = ostr else {
        return .failure(FstatToJsonErr.fatalErr("invalid json data got"))
      }
      return .success(s)
    }
  }

}

public func filepath2attributes(
  _ filepath: String,
  manager: FileManager = FileManager.default,
) -> Result<[FileAttributeKey: Any], Error> {
  Result(catching: {
    try manager.attributesOfItem(atPath: filepath)
  })
}
