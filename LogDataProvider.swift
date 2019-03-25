//
//  LogDataProvider.swift
//  SwiftyBeaverTest
//
//  Created by Andrey on 22/03/2019.
//  Copyright © 2019 anddrrek. All rights reserved.
//

import Foundation

final class LogDataProvider {
    private let logPrefix = "swiftybeaver.log"

    func getLogFileURL() -> URL? {
        var logUrl: URL?
        let fileManager = FileManager.default
        guard let cachesUrl = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first,
            let fileEnumerator = fileManager.enumerator(at: cachesUrl, includingPropertiesForKeys: nil) else {
                return logUrl
        }
        while let element = fileEnumerator.nextObject() as? NSURL {
            if element.relativeString.hasSuffix(logPrefix) {
                logUrl = element as URL
                break
            }
        }
        return logUrl
    }
    
    func getLogData() -> Data? {
        guard let url = getLogFileURL() else { return nil }
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            return nil
        }
    }
    
    func clearLogFile() {
        //TODO: add here implementation for clear file
    }
}
