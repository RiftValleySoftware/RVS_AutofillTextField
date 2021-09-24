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
     */
    subscript(endsWith inKey: String, isCaseSensitive inIsCaseSensitive: Bool = false) -> [RVS_AutofillTextFieldDataSourceType] {
        let lowercasedKey = inKey.lowercased()
        
        return compactMap { !inIsCaseSensitive ? ($0.value.lowercased().hasSuffix(lowercasedKey) ? $0 : nil) : ($0.value.hasSuffix(inKey) ? $0 : nil) }
    }
    
    /* ################################################################## */
    /**
     */
    subscript(beginsWith inKey: String, isCaseSensitive inIsCaseSensitive: Bool = false) -> [RVS_AutofillTextFieldDataSourceType] {
        let lowercasedKey = inKey.lowercased()
        
        return compactMap { !inIsCaseSensitive ? ($0.value.lowercased().hasPrefix(lowercasedKey) ? $0 : nil) : ($0.value.hasPrefix(inKey) ? $0 : nil) }
    }
    
    /* ################################################################## */
    /**
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
     */
    var textDictionary: [RVS_AutofillTextFieldDataSourceType] { get }
    
    /* ################################################################## */
    /**
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
     */
    func getTextDictionaryFromThis(string: String, isCaseSensitive: Bool = false, isWildcardBefore: Bool = false, isWildcardAfter: Bool = true, maximumAutofillCount: Int = 5) -> [RVS_AutofillTextFieldDataSourceType] { [] }
}

/* ###################################################################################################################################### */
// MARK: - Special Text Field Class That Displays An AutoComplete Table, As You Type -
/* ###################################################################################################################################### */
/**
 */
@IBDesignable
open class RVS_AutofillTextField: UITextField {
    /* ################################################################## */
    /**
     */
    @IBInspectable
    public var isCaseSensitive: Bool = false
    
    /* ################################################################## */
    /**
     */
    @IBInspectable
    public var isWildcardBefore: Bool = false
    
    /* ################################################################## */
    /**
     */
    @IBInspectable
    public var isWildcardAfter: Bool = true
    
    /* ################################################################## */
    /**
     */
    @IBInspectable
    public var maximumAutofillCount: Int = 5

    /* ################################################################## */
    /**
     */
    public var dataSource: RVS_AutofillTextFieldDataSource?
}
