import Foundation

public protocol HTMLStringLexerDelegate: AnyObject {
    func lexer(
        _ lexer: HTMLStringLexer,
        foundToken token: HTMLStringLexer.Token
    )
}

public final class HTMLStringLexer {
    public enum Token: Equatable {
        case beginTag(name: String, attributes: [String: String])
        case endTag(name: String)
        case commentTag(text: String)
        case documentTag(name: String, text: String)
        case text(String)
    }

    private struct TagMatch {
        let token: Token
        let range: Range<String.Index>
    }

    public weak var delegate: HTMLStringLexerDelegate?

    /// Regex pattern with capture groups for / end tag marker (optional), tag name, and attributes (optional).
    /// Test: https://regexr.com/70t11
    private let tagPattern = #"<(\/)?(\w+)(?:\s*>|\s+(\w+=".*?")+\s*>)"#

    /// Regex pattern for comment tag with capture group for comment text.
    /// Test: https://regexr.com/70ttk
    private let commentPattern = #"<!--(.*?)-->"#

    /// Regex pattern for document tag with capture group for name and optional text.
    /// Test: https://regexr.com/70ttq
    private let documentPattern = #"<!(\w+)(?:\s*>|\s+(.*?)\s*>)"#

    private let tagRegex: NSRegularExpression
    private let commentRegex: NSRegularExpression
    private let documentRegex: NSRegularExpression

    public init(delegate: HTMLStringLexerDelegate? = nil) {
        // The tag regex is predefined and validated, and should always compile
        // swiftlint:disable force_try
        self.tagRegex = try! NSRegularExpression(pattern: tagPattern, options: .dotMatchesLineSeparators)
        self.commentRegex = try! NSRegularExpression(pattern: commentPattern, options: .dotMatchesLineSeparators)
        self.documentRegex = try! NSRegularExpression(pattern: documentPattern, options: .dotMatchesLineSeparators)
        // swiftlint:enable force_try
    }

    func read(html: String) {
        var foundTagMatch: TagMatch?
        var currentIndex = html.startIndex
        var lastTagRange = html.startIndex..<html.startIndex

        while currentIndex < html.endIndex {
            let currentCharacter = html[currentIndex]
            if currentCharacter != "<" {
                currentIndex = html.index(after: currentIndex)
                continue
            }

            // Look-ahead to discover <! tags
            let nextIndex = html.index(after: currentIndex)
            if nextIndex == html.endIndex {
                break
            }
            if html[nextIndex] == "!" {
                if let commentMatch = matchCommentTag(in: html, startIndex: currentIndex) {
                    foundTagMatch = commentMatch
                } else if let documentMatch = matchDocumentTag(in: html, startIndex: currentIndex) {
                    foundTagMatch = documentMatch
                }
            } else if let tagMatch = matchTag(in: html, startIndex: currentIndex) {
                foundTagMatch = tagMatch
            }

            if let tagMatch = foundTagMatch {
                let textBeforeTag = html[lastTagRange.upperBound..<currentIndex]
                emitText(textBeforeTag)
                emitToken(tagMatch.token)
                currentIndex = tagMatch.range.upperBound
                foundTagMatch = nil
                lastTagRange = tagMatch.range
            } else {
                currentIndex = html.index(after: currentIndex)
            }
        }
        let remainingText = html[lastTagRange.upperBound..<html.endIndex]
        emitText(remainingText)
    }

    private func emitText(_ text: Substring) {
        if text.isEmpty { return }
        emitToken(.text(String(text)))
    }

    private func emitToken(_ token: Token) {
        delegate?.lexer(self, foundToken: token)
    }

    private func matchCommentTag(in searchString: String, startIndex: String.Index) -> TagMatch? {
        let nsRange = NSRange(startIndex..<searchString.endIndex, in: searchString)
        guard
            let match = commentRegex.firstMatch(in: searchString, range: nsRange),
            match.numberOfRanges == 2,
            let tagRange = Range(match.range(at: 0), in: searchString),
            let commentRange = Range(match.range(at: 1), in: searchString)
        else {
            return nil
        }
        let comment = String(searchString[commentRange])
        return TagMatch(token: .commentTag(text: comment), range: tagRange)
    }

    private func matchDocumentTag(in searchString: String, startIndex: String.Index) -> TagMatch? {
        let nsRange = NSRange(startIndex..<searchString.endIndex, in: searchString)
        guard
            let match = documentRegex.firstMatch(in: searchString, range: nsRange),
            match.numberOfRanges == 3,
            let tagRange = Range(match.range(at: 0), in: searchString),
            let nameRange = Range(match.range(at: 1), in: searchString),
            let textRange = Range(match.range(at: 2), in: searchString)
        else {
            return nil
        }
        let name = String(searchString[nameRange])
        let text = String(searchString[textRange])
        return TagMatch(token: .documentTag(name: name, text: text), range: tagRange)
    }

    private func matchTag(in searchString: String, startIndex: String.Index) -> TagMatch? {
        let nsRange = NSRange(startIndex..<searchString.endIndex, in: searchString)
        guard
            let match = tagRegex.firstMatch(in: searchString, range: nsRange),
            match.numberOfRanges == 4,
            let tagRange = Range(match.range(at: 0), in: searchString),
            let nameRange = Range(match.range(at: 2), in: searchString),
            let attributesRange = Range(match.range(at: 3), in: searchString)
        else {
            return nil
        }
        let isEndTagNSRange = match.range(at: 1)
        let isEndTag = isEndTagNSRange.lowerBound != NSNotFound
        let name = String(searchString[nameRange])
        if isEndTag {
            return TagMatch(token: .endTag(name: name), range: tagRange)
        } else {
            // TODO: Parse attributes
            let attributesString = String(searchString[attributesRange])
            return TagMatch(token: .beginTag(name: name, attributes: [:]), range: tagRange)
        }
    }
}
