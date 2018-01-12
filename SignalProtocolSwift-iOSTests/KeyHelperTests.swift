//
//  KeyHelperTests.swift
//  libsignal-protocol-swiftTests
//
//  Created by User on 08.11.17.
//  Copyright © 2017 User. All rights reserved.
//

import XCTest
@testable import SignalProtocolSwift


class KeyHelperTests: XCTestCase {

    override func setUp() {
        super.setUp()
        SignalCrypto.provider = TestFakeCryptoProvider()
    }
    
    func testGenerateIdentityKeyPair() {
        let identityKeyPair = Data([
            0x0a, 0x21, 0x05, 0x8f, 0x40, 0xc5, 0xad, 0xb6,
            0x8f, 0x25, 0x62, 0x4a, 0xe5, 0xb2, 0x14, 0xea,
            0x76, 0x7a, 0x6e, 0xc9, 0x4d, 0x82, 0x9d, 0x3d,
            0x7b, 0x5e, 0x1a, 0xd1, 0xba, 0x6f, 0x3e, 0x21,
            0x38, 0x28, 0x5f, 0x12, 0x20, 0x00, 0x01, 0x02,
            0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a,
            0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x10, 0x11, 0x12,
            0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a,
            0x1b, 0x1c, 0x1d, 0x1e, 0x5f])

        guard let keyPair = try? KeyPair() else {
            XCTFail("Could not generate key pair")
            return
        }
        guard let serialized = try? keyPair.data() else {
            XCTFail("Could not serialize identity key pair")
            return
        }
        guard identityKeyPair.count == serialized.count else {
            XCTFail("Lengths don't match")
            return
        }

        guard serialized == identityKeyPair else {
            XCTFail("Key pairs don't match")
            return
        }
    }
    
    func testGeneratePreKeys() {
        
        let prekey1  = Data([
            0x08, 0x01, 0x12, 0x21, 0x05, 0x8f, 0x40, 0xc5,
            0xad, 0xb6, 0x8f, 0x25, 0x62, 0x4a, 0xe5, 0xb2,
            0x14, 0xea, 0x76, 0x7a, 0x6e, 0xc9, 0x4d, 0x82,
            0x9d, 0x3d, 0x7b, 0x5e, 0x1a, 0xd1, 0xba, 0x6f,
            0x3e, 0x21, 0x38, 0x28, 0x5f, 0x1a, 0x20, 0x00,
            0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08,
            0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x10,
            0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18,
            0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x5f])
        
        let prekey2  = Data([
            0x08, 0x02, 0x12, 0x21, 0x05, 0x35, 0x80, 0x72,
            0xd6, 0x36, 0x58, 0x80, 0xd1, 0xae, 0xea, 0x32,
            0x9a, 0xdf, 0x91, 0x21, 0x38, 0x38, 0x51, 0xed,
            0x21, 0xa2, 0x8e, 0x3b, 0x75, 0xe9, 0x65, 0xd0,
            0xd2, 0xcd, 0x16, 0x62, 0x54, 0x1a, 0x20, 0x20,
            0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28,
            0x29, 0x2a, 0x2b, 0x2c, 0x2d, 0x2e, 0x2f, 0x30,
            0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38,
            0x39, 0x3a, 0x3b, 0x3c, 0x3d, 0x3e, 0x7f])
        
        let prekey3  = Data([
            0x08, 0x03, 0x12, 0x21, 0x05, 0x79, 0xa6, 0x31,
            0xee, 0xde, 0x1b, 0xf9, 0xc9, 0x8f, 0x12, 0x03,
            0x2c, 0xde, 0xad, 0xd0, 0xe7, 0xa0, 0x79, 0x39,
            0x8f, 0xc7, 0x86, 0xb8, 0x8c, 0xc8, 0x46, 0xec,
            0x89, 0xaf, 0x85, 0xa5, 0x1a, 0x1a, 0x20, 0x40,
            0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48,
            0x49, 0x4a, 0x4b, 0x4c, 0x4d, 0x4e, 0x4f, 0x50,
            0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58,
            0x59, 0x5a, 0x5b, 0x5c, 0x5d, 0x5e, 0x5f])
        
        let prekey4  = Data([
            0x08, 0x04, 0x12, 0x21, 0x05, 0x67, 0x5d, 0xd5,
            0x74, 0xed, 0x77, 0x89, 0x31, 0x0b, 0x3d, 0x2e,
            0x76, 0x81, 0xf3, 0x79, 0x0b, 0x46, 0x6c, 0x77,
            0x3b, 0x15, 0x21, 0xfe, 0xcf, 0x36, 0x57, 0x79,
            0x58, 0x37, 0x1e, 0xa5, 0x2f, 0x1a, 0x20, 0x60,
            0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68,
            0x69, 0x6a, 0x6b, 0x6c, 0x6d, 0x6e, 0x6f, 0x70,
            0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78,
            0x79, 0x7a, 0x7b, 0x7c, 0x7d, 0x7e, 0x7f])
        
        /* Generate a list of 4 pre-keys */
        guard let prekeys = try? SignalCrypto.generatePreKeys(start: 1, count: 4) else {
            XCTFail("Could not generate pre keys")
            return
        }
        guard prekeys.count == 4 else {
            XCTFail("\(prekeys.count) prekeys generated, not 4")
            return
        }
        let p1 = prekeys[0]
        guard let b1 = try? p1.data(), prekey1 == b1 else {
            XCTFail("Prekey 1 doesn't match")
            return
        }
        let p2 = prekeys[1]
        guard let b2 = try? p2.data(), prekey2 == b2 else {
            XCTFail("Prekey 2 doesn't match")
            return
        }
        let p3 = prekeys[2]
        guard let b3 = try? p3.data(), prekey3 == b3 else {
            XCTFail("Prekey 3 doesn't match")
            return
        }
        let p4 = prekeys[3]
        guard let b4 = try? p4.data(), prekey4 == b4 else {
            XCTFail("Prekey 4 doesn't match")
            return
        }
    }

    func testGenerateSignedPreKey() {
        let timestamp: UInt64 = 1411152577000
        let signedPreKey = Data([
            0x08, 0xd2, 0x09, 0x12, 0x21, 0x05, 0x35, 0x80,
            0x72, 0xd6, 0x36, 0x58, 0x80, 0xd1, 0xae, 0xea,
            0x32, 0x9a, 0xdf, 0x91, 0x21, 0x38, 0x38, 0x51,
            0xed, 0x21, 0xa2, 0x8e, 0x3b, 0x75, 0xe9, 0x65,
            0xd0, 0xd2, 0xcd, 0x16, 0x62, 0x54, 0x1a, 0x20,
            0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27,
            0x28, 0x29, 0x2a, 0x2b, 0x2c, 0x2d, 0x2e, 0x2f,
            0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37,
            0x38, 0x39, 0x3a, 0x3b, 0x3c, 0x3d, 0x3e, 0x7f,
            0x22, 0x40, 0xd8, 0x12, 0x88, 0xf2, 0x77, 0x38,
            0x08, 0x86, 0xac, 0xa4, 0x06, 0x2f, 0x06, 0xd8,
            0x30, 0xe6, 0xab, 0x73, 0x39, 0x4c, 0x85, 0xa0,
            0xc0, 0x5a, 0x81, 0x16, 0x3d, 0x21, 0x9c, 0x77,
            0xed, 0x41, 0xc1, 0x2d, 0x72, 0x61, 0x25, 0x4f,
            0xf4, 0x11, 0x64, 0xba, 0x6d, 0x89, 0x5c, 0x09,
            0x6c, 0x5e, 0x1f, 0xa6, 0xaa, 0x42, 0x53, 0x8d,
            0xb9, 0xe2, 0x6b, 0xbb, 0xb0, 0xb3, 0x6c, 0x99,
            0x74, 0x04, 0x29, 0xe8, 0x81, 0x3f, 0x8f, 0x48,
            0x01, 0x00, 0x00])
        
        guard let identityKeyPair = try? SignalCrypto.generateIdentityKeyPair() else {
            XCTFail("Could not generate identity key pair")
            return
        }
        guard let signed = try? SignalCrypto.generateSignedPreKey(
            identitykeyPair: identityKeyPair,
            id: 1234,
            timestamp: timestamp) else {
                XCTFail("Could not create signed pre key")
                return
        }
        guard let bytes = try? signed.data(), signedPreKey == bytes else {
            XCTFail("Signed key doesn't match")
            return
        }
    }

}
