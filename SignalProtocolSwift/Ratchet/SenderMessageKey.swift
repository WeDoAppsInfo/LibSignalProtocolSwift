//
//  SenderMessageKey.swift
//  libsignal-protocol-swift
//
//  Created by User on 25.10.17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

/**
 A message key in a chain to encrypt/decrypt messages
 */
struct SenderMessageKey {

    /// The info used when creating the keys from the seed
    private static let infoMaterial = "WhisperGroup".data(using: .utf8)!

    /// The length of the initialization vector
    private static let ivLength = 16

    /// The length of the key
    private static let cipherKeyLength = 32

    /// The combined length of iv and key
    private static let secretLength = ivLength + cipherKeyLength

    /// The iteration of the message key in the chain
    var iteration: UInt32

    /// The initialization vector
    var iv: Data

    /// The encryption/decryption key
    var cipherKey: Data

    /// The seed used to derive the key and iv
    private var seed: Data

    /**
     Create a message key from the components.
     - parameter iteration: The iteration of the message key in the chain
     - parameter seed: The seed used to derive the key and iv
     - throws: `SignalError` of type `hmacError`, if the HMAC authentication fails
    */
    init(iteration: UInt32, seed: Data) throws {
        let salt = Data(count: RatchetChainKey.hashOutputSize)

        let kdf = HKDF(messageVersion: .version3)
        let derivative = try kdf.deriveSecrets(material: seed,
                                               salt: salt,
                                               info: SenderMessageKey.infoMaterial,
                                               outputLength: SenderMessageKey.secretLength)

        self.iteration = iteration
        self.seed = seed
        self.iv = derivative[0..<SenderMessageKey.ivLength]
        self.cipherKey = derivative.advanced(by: SenderMessageKey.ivLength)
    }
}

// MARK: Protocol Buffers

extension SenderMessageKey {

    /**
     Create a message key from a ProtoBuf object.
     - parameter object: The message key ProtoBuf object.
     - throws: `SignalError` of type `invalidProtoBuf`, if data is missing or corrupt
     */
    init(from object: Textsecure_SenderKeyStateStructure.SenderMessageKey) throws {
        guard object.hasIteration, object.hasSeed else {
            throw SignalError(.invalidProtoBuf, "Missing data in SenderMessageKey ProtoBuf object")
        }
        try self.init(iteration: object.iteration, seed: object.seed)
    }

    /// Convert the sender chain key to a ProtoBuf object
    var object: Textsecure_SenderKeyStateStructure.SenderMessageKey {
        return Textsecure_SenderKeyStateStructure.SenderMessageKey.with {
            $0.iteration = self.iteration
            $0.seed = Data(self.seed)
        }
    }
}

// MARK: Equatable protocol

extension SenderMessageKey: Equatable {

    /**
     Compare two sender message keys for equality.
     - parameter lhs: The first key
     - parameter rhs: The second key
     - returns: `True`, if the keys are equal
     */
    static func ==(lhs: SenderMessageKey, rhs: SenderMessageKey) -> Bool {
        return lhs.iteration == rhs.iteration &&
            lhs.iv == rhs.iv &&
            lhs.seed == rhs.seed &&
            lhs.cipherKey == rhs.cipherKey
    }
}
