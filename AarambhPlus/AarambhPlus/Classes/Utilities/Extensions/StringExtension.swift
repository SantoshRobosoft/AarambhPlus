//
//  StringExtension.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/5/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import Foundation
import UIKit

extension String {
    /**
     Returns count of characters in String.
     */
    var length: Int {
        return count
    }
    
    func beginsWith(_ str: String) -> Bool {
        if let range = self.range(of: str) {
            return range.lowerBound == self.startIndex
        }
        return false
    }
    
    func relaceString() -> String {
        if self.contains("http:") {
            return self.replacingFirstOccurrenceOfString(target: "http:", withString: "https:")
        }
        return self
    }
    
    
    /// Call this method to check a string is  numeric or not
    ///
    /// - Returns: bool value
    func isNumericVal() -> Bool {
        if isEmpty {
            return false
        }
        
        let range = self.replacingOccurrences(of: " ", with: "").rangeOfCharacter(from: CharacterSet.decimalDigits.inverted)
        return (range == nil)
    }
    
    func isValidMobileNumber() -> Bool {
        return (self.count == 10) && self.isNumericVal()
    }
    
    func isValidPincode() -> Bool {
        return (self.count == 6) && self.isNumericVal()
    }
    
    func endsWith(str: String) -> Bool {
        if let range = self.range(of: str, options: String.CompareOptions.backwards, range: nil, locale: nil) {
            return range.upperBound == self.endIndex
        }
        return false
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    func trimFilePart() -> String {
        return self.replacingOccurrences(of: "file://", with: "")
    }
    
    func trimNewLine() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func toBool() -> Bool? {
        switch self {
        case "true", "True", "TRUE", "yes", "1":
            return true
        case "false", "False", "FALSE", "no", "0":
            return false
        default:
            return nil
        }
    }
    
    func toDouble() -> Double? {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en_US_POSIX")
        return numberFormatter.number(from: self)?.doubleValue
    }
    
    func indexOf(string: String) -> String.Index? {
        return range(of: string, options: String.CompareOptions.literal, range: nil, locale: nil)?.lowerBound
    }
    
    func replacingFirstOccurrenceOfString(target: String, withString replaceString: String) -> String {
        if let range = self.range(of: target) {
            return self.replacingCharacters(in: range, with: replaceString)
        }
        return self
    }
    
    func isValidEmail() -> Bool {
        //        let laxString = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        //        let emailTest = NSPredicate(format: "SELF MATCHES %@", laxString)
        let emailTest = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._]+@[A-Za-z0-9]+\\.[A-Za-z]{2,4}")
        return emailTest.evaluate(with: self)
    }
    
    func isvalidFullName() -> Bool {
        let laxString = "^[a-zA-Z][a-zA-Z ]*$" // "[A-Za-z]+(\\s[A-Za-z]+)?\\s{0,1}"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", laxString)
        return nameTest.evaluate(with: self)
    }
    
    func isvalidPassportNumber() -> Bool {
        let laxString = "^(?=.*\\d)(?=.*[a-zA-Z]*).{6,10}$"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", laxString)
        let passOne = nameTest.evaluate(with: self)
        if passOne {
            let laxStringTwo = "[a-zA-Z0-9]*"
            let nameTestTwo = NSPredicate(format: "SELF MATCHES %@", laxStringTwo)
            return nameTestTwo.evaluate(with: self)
        }
        return false
    }
    
    func isValidPassword() -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$")
        return passwordTest.evaluate(with: self)
    }
    
    static func validString(val: Any?) -> String? {
        if let val = val as? String, val.length > 0 {
            return val
        }
        return nil
    }
    
    /**
     Returns encoded String.
     decodes the string before encode in order to prevent double encoding
     */
    func stringByDecodingAndEncoding() -> String? {
        return self.removingPercentEncoding?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    static func ordinalNumberSuffix(number: Int) -> String {
        if number > 3 && number < 21 {
            return "th"
        }
        
        switch number % 10 {
        case 1: return "st"
        case 2: return "nd"
        case 3: return "rd"
        default: return "th"
        }
    }
    
    func encodeURLString() -> String {
        let newCharacterSet = CharacterSet(charactersIn: "!*'() ;:@&+$,/?%#[]").inverted
        if let encodedString = self.addingPercentEncoding(withAllowedCharacters: newCharacterSet) {
            return encodedString
        } else {
            return self
        }
    }
    
    func updateFormatsForLocalization() -> String {
        var localisedString = self
        var updatedString = self.replacingOccurrences(of: ",", with: " ")
        updatedString = updatedString.replacingOccurrences(of: "-", with: " ")
        let updatedStringsArray = updatedString.components(separatedBy: " ")
        for subString in updatedStringsArray {
            localisedString = localisedString.replacingOccurrences(of: subString, with: NSLocalizedString(subString, comment: subString))
        }
        return localisedString
    }
    
    func secondNameFromFullName() -> String? {
        let str = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if str.length > 0 {
            let nameSplit = str.components(separatedBy: " ")
            if nameSplit.count > 1 {
                return nameSplit.last
            }
        }
        return nil
    }
    
    func isBlank() -> Bool {
        if self.length == 0 {
            return true
        } else if self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).length == 0 {
            return true
        }
        return false
    }
    
    func removeHTMLTag() -> String? {
        let attributedString = try? NSAttributedString(data: self.data(using: .utf8)!,
                                                       options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
                                                       documentAttributes: nil)
        return attributedString?.string
    }
    
    // MARK: - URL encode-decode for model cache
    
    static func stringArchiveEncode(string: String) -> Data? {
        var stringData: Data?
        if let data = string.data(using: String.Encoding.utf8) {
            stringData = data.base64EncodedData(options: Data.Base64EncodingOptions.lineLength76Characters)
        }
        return stringData
    }
    
    static func stringArchiveDecode(data: Data) -> String? {
        var decodedString: String?
        if let decodedData = Data(base64Encoded: data, options: .ignoreUnknownCharacters) {
            decodedString = String(data: decodedData, encoding: String.Encoding.utf8)
        }
        
        return decodedString
    }
    
    func initialString() -> String? {
        if !self.isEmpty {
            return String(self.prefix(1))
        }
        return nil
    }
    
    /// Call this method to get the exact height for the string content, make sure the width is correct
    ///
    /// - Parameters:
    ///   - font: font
    ///   - width: content width
    ///   - numberOfLine: number of line need to be shown
    /// - Returns: height of the content
    func heightForLabelWith(font: UIFont, width: CGFloat, numberOfLine: Int = 0) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = numberOfLine
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()
        return label.frame.height
    }
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return boundingBox.height
    }
    
    /// Convenience method to calculate the width of the string
    ///
    /// - Parameter:
    ///   - height: height
    ///   - font: font
    /// - Returns: width of the content
    func widthWithConstrainedHeight(height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return boundingBox.width
    }
    
    func flattenHTMLString() -> String? {
        guard let htmlData = self.data(using: String.Encoding.utf8) else { return nil }
        do {
            return try NSAttributedString(data: htmlData,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil).string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func isHtmlString() -> String? {
        guard let htmlData = self.data(using: String.Encoding.utf8) else { return nil }
        do {
            return try NSAttributedString(data: htmlData,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil).string
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func sizeForAttributes(attributes: [NSAttributedStringKey: AnyObject], maxWidth: CGFloat) -> CGSize {
        return (self as NSString).boundingRect(with: CGSize(width: maxWidth,
                                                            height: CGFloat.greatestFiniteMagnitude),
                                               options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                               attributes: attributes,
                                               context: nil).size
    }
    
    func index(of string: String, options: String.CompareOptions = .literal) -> String.Index? {
        return range(of: string, options: options)?.lowerBound
    }
    
    func indexDistance(of substring: String) -> Int? {
        guard let index = index(of: substring) else { return nil }
        return distance(from: startIndex, to: index)
    }
    
    func removeWhitespaces() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    func widthWithConstrainedHeight(height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        return boundingBox.width
    }
}






