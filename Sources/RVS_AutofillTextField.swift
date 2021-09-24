/* ###################################################################################################################################### */
/**
 © Copyright 2018-2021, The Great Rift Valley Software Company.
 
 MIT License
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
 modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 The Great Rift Valley Software Company: https://riftvalleysoftware.com
 */

import UIKit

/* ###################################################################################################################################### */
// MARK: - One Element of the Data Source Array -
/* ###################################################################################################################################### */
/**
 This is what the protocol needs to provide to the widget.
 It is one element of an Array.
 The purpose of this type, is to allow data context to be attached to a value, and to allow the Array type to be extended.
 */
public class RVS_AutofillTextFieldDataSourceType {
    /* ################################################################## */
    /**
     The actual String value of this element. Comparisons will happen within this.
     */
    let value: String

    /* ################################################################## */
    /**
     This is an arbitrary associated data type. It can be anything, and will be associated with the String value. It should be noted that this will be a strong reference to classes.
     */
    let refCon: Any?

    /* ################################################################## */
    /**
     Standard initializer
     
     - parameter value: Required (and must be non-blank). The String value.
     - parameter refCon: Optional (default is nil). This is an arbitrary data item that is associated with this instance. It should be noted that this will be a strong reference to classes.
     */
    init(value inValue: String, refCon inRefCon: Any? = nil) {
        precondition(!inValue.isEmpty, "Value Must Be Non-Blank!")
        value = inValue
        refCon = inRefCon
    }
}

/* ###################################################################################################################################### */
// MARK: Equatable Conformance
/* ###################################################################################################################################### */
extension RVS_AutofillTextFieldDataSourceType: Equatable {
    /* ################################################################## */
    /**
     Equality tester
     - parameter lhs: Left-hand side of the comparison.
     - parameter rhs: Right-hand side of the comparison.
     - returns: True, if the the two parameters are equal.
     */
    public static func == (lhs: RVS_AutofillTextFieldDataSourceType, rhs: RVS_AutofillTextFieldDataSourceType) -> Bool { lhs.value == rhs.value }
}

/* ###################################################################################################################################### */
// MARK: Comparable Conformance
/* ###################################################################################################################################### */
extension RVS_AutofillTextFieldDataSourceType: Comparable {
    /* ################################################################## */
    /**
     Comparison tester
     - parameter lhs: Left-hand side of the comparison.
     - parameter rhs: Right-hand side of the comparison.
     - returns: True, if the lhs is less than rhs
     */
    public static func < (lhs: RVS_AutofillTextFieldDataSourceType, rhs: RVS_AutofillTextFieldDataSourceType) -> Bool { lhs.value < rhs.value }
}

/* ###################################################################################################################################### */
// MARK: - Array Extension, for Getting Values by Key -
/* ###################################################################################################################################### */
/**
 This Array extension adds some fairly basic subscript specializations, that allow the match testing to happen.
 */
extension Array where Element == RVS_AutofillTextFieldDataSourceType {
    /* ################################################################## */
    /**
     This looks for an exact match. It can be case-blind (by default).
     
     - parameter is: This is the String to test against. The entire value must match, but can be case-blind.
     - parameter isCaseSensitive: Default is false. If true, then the match needs to take case into account.
     - returns: An Array of all elements that match.
     */
    subscript(is inKey: String, isCaseSensitive inIsCaseSensitive: Bool = false) -> [RVS_AutofillTextFieldDataSourceType] {
        let lowercasedKey = inKey.lowercased()
        
        return compactMap { !inIsCaseSensitive ? (lowercasedKey == $0.value.lowercased() ? $0 : nil) : (inKey == $0.value ? $0 : nil) }
    }
    
    /* ################################################################## */
    /**
     This looks for a string that is "wildcarded" in front, but ends with the exact String. It can be case-blind (by default).
     
     - parameter endsWith: This is the String to test against. The entire value must match (but can be preceded by other characters), but can be case-blind.
     - parameter isCaseSensitive: Default is false. If true, then the match needs to take case into account.
     - returns: An Array of all elements that match.
     */
    subscript(endsWith inKey: String, isCaseSensitive inIsCaseSensitive: Bool = false) -> [RVS_AutofillTextFieldDataSourceType] {
        let lowercasedKey = inKey.lowercased()
        
        return compactMap { !inIsCaseSensitive ? ($0.value.lowercased().hasSuffix(lowercasedKey) ? $0 : nil) : ($0.value.hasSuffix(inKey) ? $0 : nil) }
    }
    
    /* ################################################################## */
    /**
     This looks for a string that is "wildcarded" after, but begins with the exact String. It can be case-blind (by default).
     
     - parameter beginsWith: This is the String to test against. The entire value must match (but can be followed by other characters), but can be case-blind.
     - parameter isCaseSensitive: Default is false. If true, then the match needs to take case into account.
     - returns: An Array of all elements that match.
     */
    subscript(beginsWith inKey: String, isCaseSensitive inIsCaseSensitive: Bool = false) -> [RVS_AutofillTextFieldDataSourceType] {
        let lowercasedKey = inKey.lowercased()
        
        return compactMap { !inIsCaseSensitive ? ($0.value.lowercased().hasPrefix(lowercasedKey) ? $0 : nil) : ($0.value.hasPrefix(inKey) ? $0 : nil) }
    }
    
    /* ################################################################## */
    /**
     This lsees if the element contains the exact String. It can be case-blind (by default).
     
     - parameter contains: This is the String to test against. The entire value must match (but can be preceded and followed by other characters), but can be case-blind.
     - parameter isCaseSensitive: Default is false. If true, then the match needs to take case into account.
     - returns: An Array of all elements that match.
     */
    subscript(contains inKey: String, isCaseSensitive inIsCaseSensitive: Bool = false) -> [RVS_AutofillTextFieldDataSourceType] {
        let lowercasedKey = inKey.lowercased()
        
        return compactMap { !inIsCaseSensitive ? ($0.value.lowercased().contains(lowercasedKey) ? $0 : nil) : ($0.value.contains(inKey) ? $0 : nil) }
    }
}

/* ###################################################################################################################################### */
// MARK: - Data Source Protocol -
/* ###################################################################################################################################### */
/**
 The text field class will require an instance of a class that conforms to this protocol. It will supply the data to be displayed in the autofill table.
 If the data source does not supply any data, then the text field acts just like any other text field.
 */
public protocol RVS_AutofillTextFieldDataSource {
    /* ################################################################## */
    /**
     This is an Array of structs, that are the searchable data collection for the text field.
     If this is not implemented, or is empty, then no searches will return any results.
     */
    var textDictionary: [RVS_AutofillTextFieldDataSourceType] { get }
    
    /* ################################################################## */
    /**
     This searches the Array, for strings that match the given String, according to the parameters included with the invocation.
     The protocol default does a rather naive comparison that is likely to be sufficient for most purposes.
     - parameter string: The String to search for
     - parameter isCaseSensitive: False, by default. If true, the String must match case, as well as content.
     - parameter isWildcardBefore: False, by default. If true, then the String can be preceded by other characters. If false, the given String must start the value being tested.
     - parameter isWildcardAfter: True, by default. If true, then the String can be followed by other characters. If false, the given String must end the value being tested.
     - parameter maximumAutofillCount: 5, by default. This is the maximum number of results to return. The return can contain fewer elements.
     - returns: An Array of elements that conform to the `RVS_AutofillTextFieldDataSourceType` protocol.
     */
    func getTextDictionaryFromThis(string: String, isCaseSensitive: Bool, isWildcardBefore: Bool, isWildcardAfter: Bool, maximumAutofillCount: Int) -> [RVS_AutofillTextFieldDataSourceType]
}

/* ###################################################################################################################################### */
// MARK: Defaults
/* ###################################################################################################################################### */
extension RVS_AutofillTextFieldDataSource {
    /* ################################################################## */
    /**
     Default is an empty Array.
     */
    var textDictionary: [RVS_AutofillTextFieldDataSourceType] { [] }
    
    /* ################################################################## */
    /**
     Default uses the Array extension subscripts to search the Array.
     */
    func getTextDictionaryFromThis(string inString: String, isCaseSensitive inIsCaseSensitive: Bool = false, isWildcardBefore inIsWildcardBefore: Bool = false, isWildcardAfter inIsWildcardAfter: Bool = true, maximumAutofillCount inMaximumAutofillCount: Int = 5) -> [RVS_AutofillTextFieldDataSourceType] {
        
        var ret = [RVS_AutofillTextFieldDataSourceType]()
        
        if !inIsWildcardBefore,
           !inIsWildcardAfter {
            ret = textDictionary[is: inString, isCaseSensitive: inIsCaseSensitive]
        } else if inIsWildcardBefore,
                  !inIsWildcardAfter {
            ret = textDictionary[endsWith: inString, isCaseSensitive: inIsCaseSensitive]
        } else if !inIsWildcardBefore,
                  inIsWildcardAfter {
            ret = textDictionary[beginsWith: inString, isCaseSensitive: inIsCaseSensitive]
        } else {
            ret = textDictionary[contains: inString, isCaseSensitive: inIsCaseSensitive]
        }
        
        let maxCount = max(0, min(ret.count, inMaximumAutofillCount))
        
        return [RVS_AutofillTextFieldDataSourceType](ret[0..<maxCount])
    }
}

/* ###################################################################################################################################### */
// MARK: - Special Text Field Class That Displays An AutoComplete Table, As You Type -
/* ###################################################################################################################################### */
/**
 This class overloads the standard UITextField widget to provide a realtime "dropdown" menu of possible autocomplete choices (in a table and modal-style screen).
 If the user selects a value from the table, that entire string is entered into the text field, and the dropdown is dismissed.
 */
@IBDesignable
open class RVS_AutofillTextField: UITextField {
    /* ################################################################## */
    /**
     This specifies whether or not matches are case-blind (default), or case-sensitive (true).
     */
    @IBInspectable
    public var isCaseSensitive: Bool = false
    
    /* ################################################################## */
    /**
     If true (default is false), then the match is made at the end of the string.
     */
    @IBInspectable
    public var isWildcardBefore: Bool = false
    
    /* ################################################################## */
    /**
     If true (default is true), then the match is made at the beginning of the string.
     */
    @IBInspectable
    public var isWildcardAfter: Bool = true
    
    /* ################################################################## */
    /**
     This is the maximum number of results to be returned. Default is 5.
     */
    @IBInspectable
    public var maximumAutofillCount: Int = 5

    /* ################################################################## */
    /**
     This is the data source for this widget. Be aware that this is a strong reference.
     */
    public var dataSource: RVS_AutofillTextFieldDataSource?
}
