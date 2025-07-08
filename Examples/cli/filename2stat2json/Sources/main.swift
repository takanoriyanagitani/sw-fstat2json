import struct FileStatToJson.BasicFileInfo
import class Foundation.ProcessInfo

func filename2stat2jsonString(_ filename: String) -> Result<String, Error> {
  let rinfo: Result<BasicFileInfo, _> = BasicFileInfo.fromFilepath(filename)
  return rinfo.flatMap { $0.toJSONString() }
}

func env2filename(_ processInfo: ProcessInfo = .processInfo) -> String {
  let env: [String: String] = processInfo.environment
  return env["ENV_FILENAME"] ?? ""
}

@main
struct FilenameToStatToJson {
  static func main() {
    let filename: String = env2filename()
    let rstatJson: Result<String, _> = filename2stat2jsonString(filename)

    do {
      let sjson: String = try rstatJson.get()
      print("\( sjson )")
    } catch {
      print("\( error )")
    }
  }
}
