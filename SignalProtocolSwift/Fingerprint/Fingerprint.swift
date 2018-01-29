//
//  Fingerprint.swift
//  SignalProtocolSwift
//
//  Created by User on 10.11.17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

/**
 A fingerprint can be used to ensure that the identities of a communication channel
 match, and to detect MITM attacks.
 */
public struct Fingerprint {

    /// The version of the fingerprint
    static let version: UInt8 = 0

    /// The length of a fingerprint
    public static let length = 30

    /// The displayable part of the fingerprint
    public let displayable: DisplayableFingerprint

    /// The scannable part of the fingerprint
    public let scannable: ScannableFingerprint

    /**
     Create a new fingerprint.
     - parameter iterations: The number of iterations for the creation of the fingerprints
     - parameter localStableIdentifier: The id of the local party
     - parameter localIdentity: Identity data of the local party
     - parameter remoteStableIdentifier: The id of the remote party
     - parameter remoteIdentity: Identity data of the remote party
     - throws: `SignalError` errors
     */
    public init(iterations: Int,
         localStableIdentifier: String,
         localIdentity: Data,
         remoteStableIdentifier: String,
         remoteIdentity: Data) throws {

        let localFingerprint = try getFingerprint(
            identity: localIdentity,
            stableIdentifier: localStableIdentifier,
            iterations: iterations)

        let remoteFingerprint = try getFingerprint(
            identity: remoteIdentity,
            stableIdentifier: remoteStableIdentifier,
            iterations: iterations)

        self.displayable = try DisplayableFingerprint(
            localFingerprint: localFingerprint,
            remoteFingerprint: remoteFingerprint)

        self.scannable = try ScannableFingerprint(
            localFingerprint: localFingerprint,
            remoteFingerprint: remoteFingerprint)
    }

    /**
     Create a new fingerprint.
     - parameter iterations: The number of iterations for the creation of the fingerprints
     - parameter localStableIdentifier: The id of the local party
     - parameter localIdentity: The public key of the local party
     - parameter remoteStableIdentifier: The id of the remote party
     - parameter remoteIdentity: The public key of the remote party
     - throws: `SignalError` errors
     */
    public init(iterations: Int,
         localStableIdentifier: String,
         localIdentity: PublicKey,
         remoteStableIdentifier: String,
         remoteIdentity: PublicKey) throws {
        try self.init(
            iterations: iterations,
            localStableIdentifier: localStableIdentifier,
            localIdentity: localIdentity.data,
            remoteStableIdentifier: remoteStableIdentifier,
            remoteIdentity: remoteIdentity.data)
    }

    /**
     Create a new fingerprint.
     - parameter iterations: The number of iterations for the creation of the fingerprints
     - parameter localStableIdentifier: The id of the local party
     - parameter localIdentity: The public keys of the local parties
     - parameter remoteStableIdentifier: The id of the remote party
     - parameter remoteIdentity: The public keys of the remote parties
     - throws: `SignalError` errors
     */
    public init(iterations: Int,
         localStableIdentifier: String,
         localIdentityList: [PublicKey],
         remoteStableIdentifier: String,
         remoteIdentityList: [PublicKey]) throws {
        try self.init(
            iterations: iterations,
            localStableIdentifier: localStableIdentifier,
            localIdentity: getLogicalKey(for: localIdentityList),
            remoteStableIdentifier: remoteStableIdentifier,
            remoteIdentity: getLogicalKey(for: remoteIdentityList))
    }
}

/**
 Serialize the list of public keys by first sorting the keys and then
 concatenating the key data.
 - parameter keyList: The public keys
 - returns: The data of the sorted keys
 */
private func getLogicalKey(for keyList: [PublicKey]) -> Data {
    let list = keyList.sorted()

    return list.reduce(Data()) { (data: Data, key: PublicKey) -> Data in
        return data + key.data
    }
}

/**
 Calculate the fingerprint for identity data and identifier.
 - parameter identity: The serialized public key of the party
 - parameter stableIdentifier: The String description of the party
 - returns: The fingerprint data
 - throws `SignalError.invalidLength` if the SHA512 digest is too short
 */
private func getFingerprint(identity: Data, stableIdentifier: String, iterations: Int) throws -> Data {
    guard let id = stableIdentifier.data(using: .utf8) else {
        throw SignalError(.unknown, "Stable identifier \(stableIdentifier) could not be converted to data")
    }
    var hashBuffer = Data([0, Fingerprint.version]) + identity + id
    for _ in 0..<iterations {
        hashBuffer = try SignalCrypto.sha512(for: hashBuffer + identity)
    }
    guard hashBuffer.count >= Fingerprint.length else {
        throw SignalError(.invalidLength, "Invalid SHA512 hash length \(hashBuffer.count)")
    }
    return hashBuffer
}
