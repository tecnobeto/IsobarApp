////////////////////////////////////////////////////////////////////////////
//
// Copyright 2014 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////

import Realm

#if swift(>=3.0)

/// :nodoc:
extension Realm {
    /**
     Struct that describes the error codes within the Realm error domain.
     The values can be used to catch a variety of _recoverable_ errors, especially those
     happening when initializing a Realm instance.

     ```swift
     let realm: Realm?
     do {
         realm = Realm()
     } catch Realm.Error.incompatibleLockFile {
         print("Realm Browser app may be attached to Realm on device?")
     }
     ```
    */
    public struct Error {
        // swiftlint:disable:next nesting
        public enum Code: Int {
            /// - see: `Realm.Error.fail`
            case fail

            /// - see: `Realm.Error.fileAccess`
            case fileAccess

            /// - see: `Realm.Error.filePermissionDenied`
            case filePermissionDenied

            /// - see: `Realm.Error.fileExists`
            case fileExists

            /// - see: `Realm.Error.fileNotFound`
            case fileNotFound

            /// - see: `Realm.Error.incompatibleLockFile`
            case incompatibleLockFile

            /// - see: `Realm.Error.fileFormatUpgradeRequired`
            case fileFormatUpgradeRequired

            /// - see: `Realm.Error.addressSpaceExhausted`
            case addressSpaceExhausted

            /// - see: `Realm.Error.schemaMismatch`
            case schemaMismatch
        }

        /// Error thrown by Realm if no other specific error is returned when a realm is opened.
        public static let fail: Code = .fail

        /// Error thrown by Realm for any I/O related exception scenarios when a realm is opened.
        public static let fileAccess: Code = .fileAccess

        /// Error thrown by Realm if the user does not have permission to open or create
        /// the specified file in the specified access mode when the realm is opened.
        public static let filePermissionDenied: Code = .filePermissionDenied

        /// Error thrown by Realm if the file already exists when a copy should be written.
        public static let fileExists: Code = .fileExists

        /// Error thrown by Realm if no file was found when a realm was opened as
        /// read-only or if the directory part of the specified path was not found
        /// when a copy should be written.
        public static let fileNotFound: Code = .fileNotFound

        /// Error thrown by Realm if the database file is currently open in another process which
        /// cannot share with the current process due to an architecture mismatch.
        public static let incompatibleLockFile: Code = .incompatibleLockFile

        /// Error thrown by Realm if a file format upgrade is required to open the file,
        /// but upgrades were explicitly disabled.
        public static let fileFormatUpgradeRequired: Code = .fileFormatUpgradeRequired

        /// Error thrown by Realm if there is insufficient available address space.
        public static let addressSpaceExhausted: Code = .addressSpaceExhausted

        /// Error thrown by Realm if there is a schema version mismatch, so that a migration is required.
        public static let schemaMismatch: Code = .schemaMismatch

        /// :nodoc:
        public var code: Code {
            let rlmError = _nsError as! RLMError
            switch rlmError.code {
            case .fail:
                return .fail
            case .fileAccess:
                return .fileAccess
            case .filePermissionDenied:
                return .filePermissionDenied
            case .fileExists:
                return .fileExists
            case .fileNotFound:
                return .fileNotFound
            case .incompatibleLockFile:
                return .incompatibleLockFile
            case .fileFormatUpgradeRequired:
                return .fileFormatUpgradeRequired
            case .addressSpaceExhausted:
                return .addressSpaceExhausted
            case .schemaMismatch:
                return .schemaMismatch
            }
        }

        /// :nodoc:
        public var _nsError: NSError // swiftlint:disable:this variable_name

        /// :nodoc:
        public init(_nsError error: NSError) {
            _nsError = error
        }
    }
}

/// :nodoc:
// Provide bridging from errors with domain RLMErrorDomain to Error.
extension Realm.Error: _BridgedStoredNSError {
    /// :nodoc:
    public static var _nsErrorDomain = RLMErrorDomain // swiftlint:disable:this variable_name
}

/// :nodoc:
extension Realm.Error.Code: _ErrorCodeProtocol {
    /// :nodoc:
    public typealias _ErrorType = RLMError // swiftlint:disable:this type_name
}

// MARK: Equatable

extension Realm.Error: Equatable {}

/// Returns a Boolean indicating whether the errors are identical.
public func == (lhs: Error, rhs: Error) -> Bool { // swiftlint:disable:this valid_docs
    return lhs._code == rhs._code
        && lhs._domain == rhs._domain
}

// MARK: Pattern Matching

/**
 Pattern matching matching for `Realm.Error`, so that the instances can be used with Swift's
 `do { ... } catch { ... }` syntax.
*/
public func ~= (lhs: Realm.Error, rhs: Error) -> Bool { // swiftlint:disable:this valid_docs
    return lhs == rhs
}

#else

/**
 `Error` is an enum representing all recoverable errors. It is associated with the
 Realm error domain specified in `RLMErrorDomain`.

 `Error` is a Swift `ErrorType`:

 ```swift
 let realm: Realm?
 do {
     realm = try Realm()
 } catch RealmSwift.Error.IncompatibleLockFile() {
     print("Incompatible lock file. The Realm Browser app might be attached to a Realm on the device.")
 }
 ```
*/
public enum Error: ErrorProtocol {
    // swiftlint:disable variable_name
    /// :nodoc:
    public var _code: Int {
        return rlmError.rawValue
    }

    /// :nodoc:
    public var _domain: String {
        return RLMErrorDomain
    }
    // swiftlint:enable variable_name

    /// The `RLMError` value, which can be used to derive the error code.
    fileprivate var rlmError: RLMError {
        switch self {
        case .fail:
            return RLMError.fail
        case .fileAccess:
            return RLMError.fileAccess
        case .filePermissionDenied:
            return RLMError.filePermissionDenied
        case .fileExists:
            return RLMError.fileExists
        case .fileNotFound:
            return RLMError.fileNotFound
        case .incompatibleLockFile:
            return RLMError.incompatibleLockFile
        case .fileFormatUpgradeRequired:
            return RLMError.fileFormatUpgradeRequired
        case .addressSpaceExhausted:
            return RLMError.addressSpaceExhausted
        case .schemaMismatch:
            return RLMError.schemaMismatch
        }
    }

    /// Denotes a general error that occurred when trying to open a Realm.
    case fail

    /// Denotes a file I/O error that occurred when trying to open a Realm.
    case fileAccess

    /// Denotes a file permission error that ocurred when trying to open a Realm.
    ///
    /// This error can occur if the user does not have permission to open or create
    /// the specified file in the specified access mode when opening a Realm.
    case filePermissionDenied

    /// Denotes an error where a file was to be written to disk, but another file with the same name
    /// already exists.
    case fileExists

    /// Denotes an error that occurs if a file could not be found.
    ///
    /// This error may occur if a Realm file could not be found on disk when trying to open a
    /// Realm as read-only, or if the directory part of the specified path was not found when
    /// trying to write a copy.
    case fileNotFound

    /// Denotes an error that occurs if the database file is currently open in another
    /// process which cannot share with the current process due to an
    /// architecture mismatch.
    ///
    /// This error may occur if trying to share a Realm file between an i386 (32-bit) iOS
    /// Simulator and the Realm Browser application. In this case, please use the 64-bit
    /// version of the iOS Simulator.
    case incompatibleLockFile

    /// Denotes an error that occurs if a file format upgrade is required to open the file,
    /// but upgrades were explicitly disabled.
    case fileFormatUpgradeRequired

    /// Denotes an error that occurs when there is insufficient available address space.
    case addressSpaceExhausted

    /// Denotes an error that occurs if there is a schema version mismatch, so that a migration is required.
    case schemaMismatch
}

// MARK: Equatable

extension Error: Equatable {}

/// Returns a Boolean indicating whether the errors are identical.
public func == (lhs: ErrorProtocol, rhs: ErrorProtocol) -> Bool { // swiftlint:disable:this valid_docs
    return lhs._code == rhs._code
        && lhs._domain == rhs._domain
}

// MARK: Pattern Matching

/**
 Pattern matching matching for `Realm.Error`, so that the instances can be used with Swift's
 `do { ... } catch { ... }` syntax.
*/
public func ~= (lhs: Error, rhs: ErrorProtocol) -> Bool { // swiftlint:disable:this valid_docs
    return lhs == rhs
}

#endif
