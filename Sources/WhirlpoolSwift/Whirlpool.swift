import Foundation
import WhirlpoolC

/// Whirlpool takes a message of any length less than 2^256 bits and returns a 512-bit message digest.
///
/// The authors have declared that
///
/// "WHIRLPOOL is not (and will never be) patented. It may be used free of charge for any purpose."
///
/// WHIRLPOOL was adopted by the International Organization for Standardization (ISO) in the ISO/IEC 10118-3:2004 standard.
///
/// Usage Example:
///
/// ```swift
/// import WhirlpoolSwift
///
/// let data1: Data = ...
/// let data2: Data = ...
///
/// var whirlpool = Whirlpool()
/// whirlpool.update(data: data1)
/// whirlpool.update(data: data2)
/// let digest = whirlpool.finalize()   // 64 bytes digest
/// ```
///
/// Alternatively, for minimal data, in a single line.
///
/// ```swift
/// import WhirlpoolSwift
///
/// let input = "The quick brown fox jumps over the lazy dog"
/// let digest = Whirlpool.hash(data: input.data(using: .utf8)!)    // 64 bytes digest
/// ```
///
public struct Whirlpool {
    private var nessie = NESSIEstruct()

    /// Initializes a new Whirlpool instance.
    public init() {
        NESSIEinit(&nessie)
    }

    /// Adds data to the Whirlpool hashing algorithm.
    ///
    /// - Parameter data: The data to be added to the hash.
    public mutating func update(data: Data) {
        let dataArray = [UInt8](data)   // Convert Data to [UInt8]
        NESSIEadd(dataArray, UInt(dataArray.count * 8), &nessie)
    }

    /// Finalizes the Whirlpool hashing algorithm and returns the hash value.
    ///
    /// - Returns: The final 512bit (64 bytes) hash value as Data.
    public mutating func finalize() -> Data {
        // Prepare buffer for the result
        var result = [UInt8](repeating: 0, count: 64)

        NESSIEfinalize(&nessie, &result)

        // Convert [UInt8] to Data and return
        return Data(result)
    }

    public static func hash(data: Data) -> Data {
        var whirlpool = Whirlpool()
        whirlpool.update(data: data)
        return whirlpool.finalize()
    }
}
