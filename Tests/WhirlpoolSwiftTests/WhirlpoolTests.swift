import XCTest
@testable import WhirlpoolSwift

final class WhirlpoolTests: XCTestCase {
    func testHash() throws {
        let testVectors = [
            ("", "19FA61D75522A4669B44E39C1D2E1726C530232130D407F89AFEE0964997F7A73E83BE698B288FEBCF88E3E03C4F0757EA8964E59B63D93708B138CC42A66EB3"),
            ("The quick brown fox jumps over the lazy dog", "B97DE512E91E3828B40D2B0FDCE9CEB3C4A71F9BEA8D88E75C4FA854DF36725FD2B52EB6544EDCACD6F8BEDDFEA403CB55AE31F03AD62A5EF54E42EE82C3FB35"),
            ("The quick brown fox jumps over the lazy eog", "C27BA124205F72E6847F3E19834F925CC666D0974167AF915BB462420ED40CC50900D85A1F923219D832357750492D5C143011A76988344C2635E69D06F2D38C"),
        ]

        for (input, expectedHexDigest) in testVectors {
            var whirlpool = Whirlpool()
            whirlpool.update(data: input.data(using: .utf8)!)
            let digest = whirlpool.finalize()

            XCTAssertEqual(digest, Data(hexString: expectedHexDigest), "Input: \(input)")

            XCTAssertEqual(Whirlpool.hash(data: input.data(using: .utf8)!), Data(hexString: expectedHexDigest), "Input: \(input)")
        }
    }
}

extension Data {
    init?(hexString: String) {
        // Remove any spaces or other characters that are not part of the hex string
        let cleanedHexString = hexString.replacingOccurrences(of: " ", with: "")

        // Ensure that the cleaned string has an even number of characters
        guard cleanedHexString.count % 2 == 0 else {
            return nil
        }

        var bytes = [UInt8]()

        // Process the hex string in pairs of two characters
        var index = cleanedHexString.startIndex
        while index < cleanedHexString.endIndex {
            let byteString = cleanedHexString[index ..< cleanedHexString.index(index, offsetBy: 2)]
            if let byte = UInt8(byteString, radix: 16) {
                bytes.append(byte)
            } else {
                // Invalid hex character found
                return nil
            }

            index = cleanedHexString.index(index, offsetBy: 2)
        }

        self.init(bytes)
    }
}
