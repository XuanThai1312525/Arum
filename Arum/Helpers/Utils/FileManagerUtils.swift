//
//  FileManagerUtils.swift
//  LANE4
//
//  Created by Thai Nguyen on 26/11/2020.
//  Copyright © 2020 LinhNM7. All rights reserved.
//

import Foundation
class FileManagerUtils {
    
    // MARK: - Static variables
    static let fileManager: FileManager  = FileManager.default
    static var documentDirectoryUrl: URL {
        return FileManagerUtils.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    // MARK: - Static functions
    @discardableResult
    static func saveFileWith(data: Data, name: String, atUrl url: URL = FileManagerUtils.documentDirectoryUrl) -> URL? {
        let filePath = url.appendingPathComponent("\(name)")
        do {
            try data.write(to: filePath, options: .atomic)
            return filePath
        } catch { }
        return nil
    }
    
    @discardableResult
    static func removeFileAt(url: URL) -> Bool {
        do {
            try FileManagerUtils.fileManager.removeItem(at: url)
            return true
        } catch { }
        return false
    }
}
