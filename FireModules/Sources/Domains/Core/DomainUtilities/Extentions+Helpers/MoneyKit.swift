import Foundation

/// Original link: https://gist.github.com/iwasrobbed/f32c01c6965665f5823d0e0c683867e2
public final class MoneyKit {
    public static let shared = MoneyKit()

    private init() {}

    private var symbolCache = [String: String]()
    private var currencyCodeFormatterCache = [String: NumberFormatter]()
    private var currencySymbolFormatterCache = [String: NumberFormatter]()

    /// Finds the shortest currency symbol possible and formats the amount with it
    /// Note: this works around using `currencyCode` and how it displays `CA$1234.56` instead of `$1234.56`
    /// - Parameters:
    ///   - amount: The amount you want to format
    ///   - isoCurrencyCode: ISO currency code. E.g: VND, USD, EUR
    /// - Returns: The formatted amount. Calling `currencyString(for: 1000, isoCurrencyCode: "VND")` returns "₫221,920,450.00"
    public func currencyString(for amount: Decimal, isoCurrencyCode: String?) -> String {
        guard let isoCurrencyCode,
              let currencySymbol = findSymbol(for: isoCurrencyCode)
        else { return String(describing: amount) }
        return currencyCodeFormatter(for: currencySymbol).string(for: amount) ?? String(describing: amount)
    }

    public func currencyCodeFormatter(for currencyCode: String) -> NumberFormatter {
        if let cachedFormatter = currencyCodeFormatterCache[currencyCode] { return cachedFormatter }
        let formatter = NumberFormatter()
        formatter.currencySymbol = currencyCode
        formatter.numberStyle = .currency
        currencyCodeFormatterCache[currencyCode] = formatter
        return formatter
    }

    public func currencySymbolFormatter(for currencyCode: String) -> NumberFormatter {
        if let cachedFormatter = currencySymbolFormatterCache[currencyCode] { return cachedFormatter }
        let formatter = NumberFormatter()
        formatter.currencySymbol = findSymbol(for: currencyCode)
        formatter.numberStyle = .currency
        currencySymbolFormatterCache[currencyCode] = formatter
        return formatter
    }

    public func findSymbol(for currencyCode: String) -> String? {
        if let cachedCurrencyCode = symbolCache[currencyCode] { return cachedCurrencyCode }
        guard currencyCode.count < 4 else { return nil }
        let symbol = findShortestSymbol(for: currencyCode)
        symbolCache[currencyCode] = symbol
        return symbol
    }

    private func findShortestSymbol(for currencyCode: String) -> String? {
        var candidates = [String]()
        for localeId in NSLocale.availableLocaleIdentifiers {
            guard let symbol = findSymbolBy(localeId: localeId, currencyCode: currencyCode) else { continue }
            if symbol.count == 1 { return symbol }
            candidates.append(symbol)
        }
        return candidates.sorted(by: { $0.count < $1.count }).first // find the shorted
    }

    private func findSymbolBy(localeId: String, currencyCode: String) -> String? {
        let locale = Locale(identifier: localeId)
        guard let localCurrencyCode = locale.currency?.identifier else { return nil }
        return currencyCode.caseInsensitiveCompare(localCurrencyCode) == .orderedSame ? locale.currencySymbol : nil
    }
}
