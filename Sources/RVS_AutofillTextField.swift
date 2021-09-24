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
 */
public class RVS_AutofillTextFieldDataSourceType {
    /* ################################################################## */
    /**
     */
    let value: String

    /* ################################################################## */
    /**
     */
    let refCon: Any?

    /* ################################################################## */
    /**
     */
    init(value inValue: String, refCon inRefCon: Any? = nil) {
        value = inValue
        refCon = inRefCon
    }
}

/* ###################################################################################################################################### */
// MARK: - Array Extension, for Getting Values by Key -
/* ###################################################################################################################################### */
/**
 */
extension Array where Element == RVS_AutofillTextFieldDataSourceType {
    /* ################################################################## */
    /**
     */
    var allValues: [String] { map { $0.value } }
    
    /* ################################################################## */
    /**
     */
    var allRefCons: [Any] { compactMap { $0.refCon } }
    
    // MARK: Specialized Subscripts
    
    /* ################################################################## */
    /**
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
     */
    func getTextDictionaryFromThis(string: String) -> [RVS_AutofillTextFieldDataSourceType]
}

/* ###################################################################################################################################### */
// MARK: Defaults
/* ###################################################################################################################################### */
extension RVS_AutofillTextFieldDataSource {
    /* ################################################################## */
    /**
     */
    func getTextDictionaryFromThis(string: String) -> [RVS_AutofillTextFieldDataSourceType] { [] }
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
    public var maximumCount: Int = 5

    /* ################################################################## */
    /**
     */
    public var dataSource: RVS_AutofillTextFieldDataSource? = nil
}
