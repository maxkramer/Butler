//
//  KeychainHelperTests.swift
//  Butler
//
//  Created by Max Kramer on 16/05/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

import XCTest
@testable import Butler

class KeychainHelperTests: XCTestCase {
    func testCreatesAndSaves() {
        let encryptionKey = KeychainHelper.shared.realmEncryptionKey()
        XCTAssertNotNil(encryptionKey)
        XCTAssertEqual(encryptionKey, KeychainHelper.shared.realmEncryptionKey())
    }
}
