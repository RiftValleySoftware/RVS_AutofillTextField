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
// MARK: - UIView Extension -
/* ###################################################################################################################################### */
/**
 We can add auto-layout-prescribed views.
 */
extension UIView {
    /* ################################################################## */
    /**
     This allows us to add a subview, and set it up with auto-layout constraints to fill the superview.
     
     - parameter inSubview: The subview we want to add.
     - parameter underThis: If supplied, this is a Y-axis anchor to use as the attachment of the top anchor. Default is nil (can be omitted, which will simply attach to the top of the container).
     - parameter andGiveMeABottomHook: If this is true, then the bottom anchor of the subview will not be attached to anything, and will simply be returned. Default is false, which means that the bottom anchor will simply be attached to the bottom of the view.
     - returns: The bottom hook, if requested. Can be ignored.
     */
    @discardableResult
    func addContainedView(_ inSubView: UIView, underThis inUpperConstraint: NSLayoutYAxisAnchor? = nil, andGiveMeABottomHook inBottomLoose: Bool = false) -> NSLayoutYAxisAnchor? {
        addSubview(inSubView)
        
        inSubView.translatesAutoresizingMaskIntoConstraints = false
        if let underConstraint = inUpperConstraint {
            inSubView.topAnchor.constraint(equalTo: underConstraint, constant: 0).isActive = true
        } else {
            inSubView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        }
        inSubView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        inSubView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        
        if inBottomLoose {
            return inSubView.bottomAnchor
        } else {
            inSubView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        }
        
        return nil
    }
}

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
        
        let localTextDictionary = textDictionary
        
        guard !localTextDictionary.isEmpty else { return [] }
        
        let ret: [RVS_AutofillTextFieldDataSourceType]
        
        if !inIsWildcardBefore,
           !inIsWildcardAfter {
            ret = localTextDictionary[is: inString, isCaseSensitive: inIsCaseSensitive]
        } else if inIsWildcardBefore,
                  !inIsWildcardAfter {
            ret = localTextDictionary[endsWith: inString, isCaseSensitive: inIsCaseSensitive]
        } else if !inIsWildcardBefore,
                  inIsWildcardAfter {
            ret = localTextDictionary[beginsWith: inString, isCaseSensitive: inIsCaseSensitive]
        } else {
            ret = localTextDictionary[contains: inString, isCaseSensitive: inIsCaseSensitive]
        }
        
        return [RVS_AutofillTextFieldDataSourceType](ret[0..<max(0, min(ret.count, inMaximumAutofillCount))])
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
     The table background will be the system background, at this transparency.
     */
    private static let _tableBackgroundAlpha: CGFloat = 0.25
    
    /* ################################################################## */
    /**
     The height of each table row.
     */
    private static let _tableRowHeightInDisplayUnits: CGFloat = 40
    
    /* ################################################################## */
    /**
     The corner rounding of the displayed table.
     */
    private static let _tableRoundedCornerInDisplayUnits: CGFloat = 16

    /* ################################################################## */
    /**
     The padding between the edges of the table, and the displays.
     */
    private static let _tablePaddingInDisplayUnits: CGFloat = RVS_AutofillTextField._tableRoundedCornerInDisplayUnits / 2.0
    
    /* ################################################################## */
    /**
     The table will display above or below the text item, and will be separated by this many display units.
     The leading edge of the table will be aligned with the edit field's leading edge.
     */
    private static let _gapInDisplayUnitsBetweenTextItemAndTable: CGFloat = 8
    
    /* ################################################################## */
    /**
     This will contain a Table View, that will display our autocompletes.
     */
    private var _autoCompleteTable: UITableView?

    /* ################################################################## */
    /**
     When the table comes up, this will be the color. The default is the standard system color, with a 0.25 alpha.
     */
    @IBInspectable
    public var tableBackgroundColor: UIColor = .systemBackground.withAlphaComponent(RVS_AutofillTextField._tableBackgroundAlpha)

    /* ################################################################## */
    /**
     This is the font to use. It must be set programmatically.
     */
    public var tableFont: UIFont = .systemFont(ofSize: 20)

    /* ################################################################## */
    /**
     The minimum width of the table. It will be at least this wide, and will follow the width of the edit text item, if it is bigger.
     It will also never go beyond the trailing edge of the screen.
     */
    @IBInspectable
    public var minimumTableWidthInDisplayUnits: CGFloat = 100

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
     This is not inspectable, and must be assigned programmatically.
     */
    public var dataSource: RVS_AutofillTextFieldDataSource?
}

/* ###################################################################################################################################### */
// MARK: Computed Properties
/* ###################################################################################################################################### */
extension RVS_AutofillTextField {
    /* ################################################################## */
    /**
     This is the current response of what needs to be displayed in the autofill.
     */
    private var _currentAutoFill: [RVS_AutofillTextFieldDataSourceType] {
        !(text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
            ? dataSource?.getTextDictionaryFromThis(string: text ?? "", isCaseSensitive: isCaseSensitive, isWildcardBefore: isWildcardBefore, isWildcardAfter: isWildcardAfter, maximumAutofillCount: maximumAutofillCount) ?? []
            : []
    }
}

/* ###################################################################################################################################### */
// MARK: Instance Methods
/* ###################################################################################################################################### */
extension RVS_AutofillTextField {
    /* ################################################################## */
    /**
     This will create a new instance of the display table, if it does not already exist.
     It may move the table, if it does exist, but the location should be changed.
     */
    private func _createAutoCompleteTable() {
        guard 0 < _currentAutoFill.count else {
            closeTableView()
            return
        }
        
        if let containerView = window?.rootViewController?.view {
            let maxTableHeight = CGFloat(maximumAutofillCount) * Self._tableRowHeightInDisplayUnits
            let maxTableWidth = max(bounds.size.width, minimumTableWidthInDisplayUnits)
            let numberOfRows = CGFloat(_currentAutoFill.count)
            let currentTableHeight = numberOfRows * Self._tableRowHeightInDisplayUnits
            let tableOrigin = convert(CGPoint(x: 0, y: bounds.size.height + Self._gapInDisplayUnitsBetweenTextItemAndTable), to: containerView)
            let tableWidth = min(containerView.bounds.width - (tableOrigin.x + Self._gapInDisplayUnitsBetweenTextItemAndTable), maxTableWidth)
            let tableFrame = CGRect(origin: tableOrigin, size: CGSize(width: tableWidth, height: currentTableHeight))
            #if DEBUG
                print("View bounds: \(containerView.bounds)")
                print("Number of rows: \(numberOfRows)")
                print("Maximum Table Height: \(maxTableHeight)")
                print("Current Table Frame: \(tableFrame)")
            #endif
            
            if !tableFrame.isEmpty {
                #if DEBUG
                    print("We have a table to be displayed.")
                #endif
                if nil == _autoCompleteTable {
                    #if DEBUG
                        print("One does not yet exist, so we will create it.")
                    #endif
                    _autoCompleteTable = UITableView(frame: tableFrame)
                    if let autoCompleteTable = _autoCompleteTable {
                        autoCompleteTable.dataSource = self
                        autoCompleteTable.backgroundColor = tableBackgroundColor
                        autoCompleteTable.rowHeight = Self._tableRowHeightInDisplayUnits
                        autoCompleteTable.layer.cornerRadius = Self._tableRoundedCornerInDisplayUnits
                        autoCompleteTable.clipsToBounds = true
                        containerView.addSubview(autoCompleteTable)
                    }
                }
                
                if let autoCompleteTable = _autoCompleteTable {
                    autoCompleteTable.frame = tableFrame
                    autoCompleteTable.reloadData()
                }
            } else if let autoCompleteTable = _autoCompleteTable {
                #if DEBUG
                    print("We have a table to be removed.")
                #endif
                autoCompleteTable.removeFromSuperview()
                _autoCompleteTable = nil
            } else {
                #if DEBUG
                    print("We do not have a table, and we won't make one.")
                #endif
            }
        }
    }
}

/* ###################################################################################################################################### */
// MARK: Callbacks
/* ###################################################################################################################################### */
extension RVS_AutofillTextField {
    /* ################################################################## */
    /**
     This callback is triggered whenever the text in the edit field has changed. This is where we test the auto-complete dictionary.
     
     - parameter inTextField: The text field (us).
     */
    @objc private func _textHasChanged(_ inTextField: UITextField) {
        #if DEBUG
            print("Text Field Changed: \(String(describing: inTextField.text))")
        #endif
        
        _createAutoCompleteTable()
    }
}

/* ###################################################################################################################################### */
// MARK: Instance Methods
/* ###################################################################################################################################### */
extension RVS_AutofillTextField {
    /* ################################################################## */
    /**
     Called to close the table view.
     */
    public func closeTableView() {
        _autoCompleteTable?.removeFromSuperview()
        _autoCompleteTable = nil
    }
}

/* ###################################################################################################################################### */
// MARK: Base Class Overrides
/* ###################################################################################################################################### */
extension RVS_AutofillTextField {
    /* ################################################################## */
    /**
     This makes sure that we remove the table, if we are no longer the focus.
     */
    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        _createAutoCompleteTable()
        return super.becomeFirstResponder()
    }
    
    /* ################################################################## */
    /**
     This makes sure that we remove the table, if we are no longer the focus.
     */
    @discardableResult
    public override func resignFirstResponder() -> Bool {
        closeTableView()
        return super.resignFirstResponder()
    }
    
    /* ################################################################## */
    /**
     Called when we trigger a layout. We use this to register our callback.
     */
    public override func layoutSubviews() {
        super.layoutSubviews()
        addTarget(self, action: #selector(_textHasChanged(_:)), for: .editingChanged)
        _createAutoCompleteTable()
    }
    
    /* ################################################################## */
    /**
     Called when we are being removed from our superview. We remove the callback (just to be sure -belt and suspenders).
     */
    public override func removeFromSuperview() {
        closeTableView()
        removeTarget(self, action: #selector(_textHasChanged(_:)), for: .editingChanged)
        super.removeFromSuperview()
    }
}

/* ###################################################################################################################################### */
// MARK: UITableViewDataSource Conformance
/* ###################################################################################################################################### */
extension RVS_AutofillTextField: UITableViewDataSource {
    /* ################################################################## */
    /**
     This returns the number of rows to display in the autofill table.
     - parameter: The table view. Ignored.
     - parameter: The section (0-based index). Ignored
     - returns: The number of rows to display.
     */
    public func tableView(_: UITableView, numberOfRowsInSection: Int) -> Int { _currentAutoFill.count }
    
    /* ################################################################## */
    /**
     This returns one cell of the table, with the specific autofill suggestion.
     */
    public func tableView(_ inTableView: UITableView, cellForRowAt inIndexPath: IndexPath) -> UITableViewCell {
        let ret = UITableViewCell()
        ret.backgroundColor = .clear
        ret.textLabel?.font = tableFont
        ret.textLabel?.text = _currentAutoFill[inIndexPath.row].value
        
        return ret
    }
}
