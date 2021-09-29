/* ###################################################################################################################################### */
/**
 © Copyright 2021, The Great Rift Valley Software Company.
 
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
// MARK: - Main Class
// MARK: Special Text Field Class That Displays An AutoComplete Table, As You Type -
/* ###################################################################################################################################### */
/**
 This class extends the standard [`UITextField`](https://developer.apple.com/documentation/uikit/uitextfield) widget to provide a realtime "dropdown" menu of possible
 autocomplete choices (in a table and modal-style screen).
 The dropdown is always displayed below the text field, and is attached to the main window root view (so it appears over everything else). It is not modal.
 If the user selects a value from the table, that entire string is entered into the text field, and the dropdown is dismissed.
 The dropdown is dismissed whenever focus leaves the text item.
 When focus is set to the text field, the current text is evaluated, and a dropdown may appear, if required.
 If the autofill functionality is not available, or is explicitly deactivated, the text item behaves exactly like a standard `UITextField`.
 **NB:** When assigning a delegate, the caller needs to be a [`UITextFieldDelegate`](https://developer.apple.com/documentation/uikit/uitextfielddelegate/),
 even if they are not using any of the delegate functionality.
 This is because we "piggyback" on the built-in delegate.
 This also means that the delegate must be an [`NSObject`](https://developer.apple.com/documentation/objectivec/nsobject).
 */
@IBDesignable
open class RVS_AutofillTextField: UITextField {
    // MARK: Private Property - GET OFF MAH LAWN!
    /* ################################################################## */
    /**
     The table background will be the system background, at this transparency.
     */
    private static let _animationDurationInSeconds: TimeInterval = 0.25
    
    /* ################################################################## */
    /**
     The table background will be the system background, at this transparency.
     */
    private static let _tableBackgroundAlpha: CGFloat = 0.75
    
    /* ################################################################## */
    /**
     Text that is not selected will be more transparent.
     */
    private static let _unselectedTextAlpha: CGFloat = 0.5
    
    /* ################################################################## */
    /**
     This establishes a minimum scale factor for the text in the dropdown.
     */
    private static let _minimumScaleFactorForText: CGFloat = 0.25

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
     This holds the height of the keyboard, in display units.
     */
    private var _keyboardHeightInDisplayUnits: CGFloat = 0

    // MARK: Default Values
    /* ################################################################## */
    /**
     The default value for case sensitivity (OFF)
     */
    public static let defaultIsCaseSensitive = false

    /* ################################################################## */
    /**
     The default value for wildcards before (OFF)
     */
    public static let defaultIsWildcardBefore = false

    /* ################################################################## */
    /**
     The default value for wildcards after (ON)
     */
    public static let defaultIsWildcardAfter = true

    /* ################################################################## */
    /**
     The default value for maximum count (5)
     */
    public static let defaultMaximumCount = 5

    // MARK: - Public Properties
    /* ################################################################## */
    /**
     When the table comes up, this will be the color. The default is the standard system color, with a 0.25 alpha.
     */
    @IBInspectable
    public var tableBackgroundColor: UIColor = .systemBackground.withAlphaComponent(RVS_AutofillTextField._tableBackgroundAlpha) { didSet { DispatchQueue.main.async { self.setNeedsLayout() } } }

    /* ################################################################## */
    /**
     This is the text color to use in the table. Default is label color.
     */
    @IBInspectable
    public var tableTextColor: UIColor = .label { didSet { DispatchQueue.main.async { self.setNeedsLayout() } } }

    /* ################################################################## */
    /**
     The minimum width of the table. It will be at least this wide, and will follow the width of the edit text item, if it is bigger.
     It will also never go beyond the trailing edge of the screen.
     */
    @IBInspectable
    public var minimumTableWidthInDisplayUnits: CGFloat = 100 { didSet { DispatchQueue.main.async { self.setNeedsLayout() } } }
    
    /* ################################################################## */
    /**
     This is the maximum number of results to be returned. Default is 5.
     If -1, then there is no limit.
     */
    @IBInspectable
    public var maximumAutofillCount: Int = defaultMaximumCount { didSet { DispatchQueue.main.async { self.setNeedsLayout() } } }

    /* ################################################################## */
    /**
     This is a "circuit breaker" for the autofill capability. Default is on. If Off, the autofill will not be shown.
     */
    @IBInspectable
    public var isAutoFillOn: Bool = true { didSet { DispatchQueue.main.async { self.setNeedsLayout() } } }

    /* ################################################################## */
    /**
     This specifies whether or not matches are case-blind (default), or case-sensitive (true).
     */
    @IBInspectable
    public var isCaseSensitive: Bool = defaultIsCaseSensitive { didSet { DispatchQueue.main.async { self.setNeedsLayout() } } }

    /* ################################################################## */
    /**
     If true (default is false), then the match is made at the end of the string.
     */
    @IBInspectable
    public var isWildcardBefore: Bool = defaultIsWildcardBefore { didSet { DispatchQueue.main.async { self.setNeedsLayout() } } }
    
    /* ################################################################## */
    /**
     If true (default is true), then the match is made at the beginning of the string.
     */
    @IBInspectable
    public var isWildcardAfter: Bool = defaultIsWildcardAfter { didSet { DispatchQueue.main.async { self.setNeedsLayout() } } }

    /* ################################################################## */
    /**
     This allows us to assign an explicit "container" view for the popover. Default is nil. If not provided, the main window root view is used.
     */
    public weak var containerView: UIView?

    /* ################################################################## */
    /**
     This is the data source for this widget. Be aware that this is a strong reference.
     This is not inspectable, and must be assigned programmatically.
     */
    public var dataSource: RVS_AutofillTextFieldDataSource?

    /* ################################################################## */
    /**
     This is the font to use. It must be set programmatically.
     */
    public var tableFont: UIFont = .systemFont(ofSize: 20)
}

/* ###################################################################################################################################### */
// MARK: Private Computed Properties
/* ###################################################################################################################################### */
extension RVS_AutofillTextField {
    /* ################################################################## */
    /**
     This is the current response of what needs to be displayed in the autofill.
     This also "cleans out" empty lines.
     */
    private var _currentAutoFill: [RVS_AutofillTextFieldDataSourceType] {
        var ret = [RVS_AutofillTextFieldDataSourceType]()
        if let text = text,
           !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            ret = dataSource?.getTextDictionaryFromThis(string: text,
                                                        isCaseSensitive: isCaseSensitive,
                                                        isWildcardBefore: isWildcardBefore,
                                                        isWildcardAfter: isWildcardAfter,
                                                        maximumAutofillCount: maximumAutofillCount) ?? []
        }
        
        return ret.compactMap { !$0.value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? $0 : nil }
    }
}

/* ###################################################################################################################################### */
// MARK: Private Callbacks
/* ###################################################################################################################################### */
extension RVS_AutofillTextField {
    /* ################################################################## */
    /**
     This callback is triggered whenever the text in the edit field has changed. This is where we test the auto-complete dictionary.
     
     - parameter inTextField: The text field (us).
     */
    @objc private func _textHasChanged(_ inTextField: UITextField) {
        _createAutoCompleteTable()
    }
    
    /* ################################################################## */
    /**
     Called when the keyboard opens.
     We use this to extract and store the height of the keyboard, so we don't go below it.
     - parameter inNotification: The notification object.
     */
    @objc private func _keyboardWasShown(_ inNotification: Notification) {
        let info = inNotification.userInfo
        if let value = info?[UIResponder.keyboardFrameEndUserInfoKey],
           let keyboardFrame = (value as AnyObject).cgRectValue {
            _keyboardHeightInDisplayUnits = keyboardFrame.height
            DispatchQueue.main.async { self.setNeedsLayout() }
        }
    }
    
    /* ################################################################## */
    /**
     Called when the keyboard closes.
     - parameter: The notification object (ignored).
     */
    @objc private func _keyboardWasHidden(_: Notification) {
        _keyboardHeightInDisplayUnits = 0
        DispatchQueue.main.async { self.setNeedsLayout() }
    }
}

/* ###################################################################################################################################### */
// MARK: Instance Methods
/* ###################################################################################################################################### */
extension RVS_AutofillTextField {
    // MARK: Private Methods
    /* ################################################################## */
    /**
     This will create a new instance of the display table, if it does not already exist.
     It may move the table, if it does exist, but the location should be changed.
     The move/open is animated.
     */
    private func _createAutoCompleteTable() {
        guard isAutoFillOn,
              0 < _currentAutoFill.count
        else {
            _closeTableView()
            return
        }
        
        if let containerView = containerView ?? window {
            let containerBounds = containerView.bounds
            let maxTableWidth = max(bounds.size.width, minimumTableWidthInDisplayUnits)
            let numberOfRows = CGFloat(_currentAutoFill.count)
            let tableOrigin = convert(CGPoint(x: 0, y: bounds.size.height + Self._gapInDisplayUnitsBetweenTextItemAndTable), to: containerView)
            let currentTableHeight = min(numberOfRows * Self._tableRowHeightInDisplayUnits,
                                         (containerBounds.height - (Self._gapInDisplayUnitsBetweenTextItemAndTable + _keyboardHeightInDisplayUnits)) - tableOrigin.y)
            let tableWidth = min(containerView.bounds.width - (tableOrigin.x + Self._gapInDisplayUnitsBetweenTextItemAndTable), maxTableWidth)
            let tableFrame = CGRect(origin: tableOrigin, size: CGSize(width: tableWidth, height: currentTableHeight))
            
            if !tableFrame.isEmpty {
                if nil == _autoCompleteTable {
                    _autoCompleteTable = UITableView(frame: tableFrame)
                    if let autoCompleteTable = _autoCompleteTable {
                        autoCompleteTable.dataSource = self
                        autoCompleteTable.delegate = self
                        autoCompleteTable.rowHeight = Self._tableRowHeightInDisplayUnits
                        autoCompleteTable.layer.cornerRadius = Self._tableRoundedCornerInDisplayUnits
                        autoCompleteTable.clipsToBounds = true
                        autoCompleteTable.frame = CGRect(origin: autoCompleteTable.frame.origin, size: CGSize(width: autoCompleteTable.frame.size.width, height: 0))
                        containerView.addSubview(autoCompleteTable)
                    }
                }
                
                _autoCompleteTable?.backgroundColor = tableBackgroundColor
                
                if let autoCompleteTable = _autoCompleteTable,
                   tableFrame != autoCompleteTable.frame {
                    autoCompleteTable.layoutIfNeeded()
                    UIView.animate(withDuration: Self._animationDurationInSeconds, animations: {
                        autoCompleteTable.frame = tableFrame
                        autoCompleteTable.layoutIfNeeded()
                    })
                }
                
                _autoCompleteTable?.reloadData()
            } else {
                _closeTableView()
            }
        }
    }

    /* ################################################################## */
    /**
     Called to close the table view, and nothing more.
     */
    private func _closeTableView() {
        _autoCompleteTable?.removeFromSuperview()
        _autoCompleteTable = nil
    }
    
    // MARK: Public Methods
    /* ################################################################## */
    /**
     Called to close the table view, and, possibly, resign as first responder.
     */
    public func closeTableViewAndResignFirstResponder() {
        _closeTableView()
        if isFirstResponder {
            resignFirstResponder()
        }
    }
}

/* ###################################################################################################################################### */
// MARK: Public Base Class Overrides
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
        _closeTableView()
        return super.resignFirstResponder()
    }
    
    /* ################################################################## */
    /**
     Called when we trigger a layout. We use this to register our callback.
     */
    public override func layoutSubviews() {
        super.layoutSubviews()
        addTarget(self, action: #selector(_textHasChanged(_:)), for: .editingChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(_keyboardWasShown(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(_keyboardWasHidden(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        if nil != _autoCompleteTable {  // This is to make sure we update the position.
            _createAutoCompleteTable()
            _autoCompleteTable?.reloadData()
        }
    }
    
    /* ################################################################## */
    /**
     Called when we are being removed from our superview. We remove the callback (just to be sure -belt and suspenders).
     */
    public override func removeFromSuperview() {
        _closeTableView()
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
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
     
     - parameter inTableView: The table view.
     - parameter cellForRowAt: The index of the cell to be returned (section will always be 0).
     - returns: A new, simple, default cell, with an attributed text content.
     */
    public func tableView(_ inTableView: UITableView, cellForRowAt inIndexPath: IndexPath) -> UITableViewCell {
        let ret = UITableViewCell()
        
        ret.backgroundColor = .clear
        ret.textLabel?.adjustsFontSizeToFitWidth = true
        ret.textLabel?.minimumScaleFactor = Self._minimumScaleFactorForText
        ret.textLabel?.showsExpansionTextWhenTruncated = true
        ret.textLabel?.lineBreakMode = .byTruncatingTail
        ret.textLabel?.font = tableFont

        if let text = text,
           !text.isEmpty,
           _currentAutoFill.count > inIndexPath.row {
            // What we do here, is pick out the matched text from the main string, and make the part that will be autofilled a bit more transparent,
            // so that means we need to figure out what we've matched.
            let searchableText = _currentAutoFill[inIndexPath.row].value
            let options = String.CompareOptions(isCaseSensitive ? [.literal] : [.caseInsensitive, .diacriticInsensitive])
            let focusedTextAttribute = [NSAttributedString.Key.foregroundColor: tableTextColor]
            let unfocusedTextAttribute = [NSAttributedString.Key.foregroundColor: tableTextColor.withAlphaComponent(Self._unselectedTextAlpha)]
            if let matchRange = searchableText.range(of: text, options: options) {
                let unmatchRangeBefore = searchableText.startIndex..<matchRange.lowerBound
                let unmatchRangeAfter = matchRange.upperBound..<searchableText.endIndex
                let attributedText = NSMutableAttributedString(string: searchableText)
                attributedText.setAttributes(focusedTextAttribute, range: NSRange(matchRange, in: searchableText))
                attributedText.setAttributes(unfocusedTextAttribute, range: NSRange(unmatchRangeBefore, in: searchableText))
                attributedText.setAttributes(unfocusedTextAttribute, range: NSRange(unmatchRangeAfter, in: searchableText))
                ret.textLabel?.attributedText = attributedText
            }
        }
        
        return ret
    }
}

/* ###################################################################################################################################### */
// MARK: UITableViewDelegate Conformance
/* ###################################################################################################################################### */
extension RVS_AutofillTextField: UITableViewDelegate {
    /* ################################################################## */
    /**
     This reacts to the user selecting a suggested text item.
     It sets the edit field text to the selected text, and closes the table.
     - parameter inTableView: The table view.
     - parameter didSelectRowAt: The index of the selected row,
     */
    public func tableView(_ inTableView: UITableView, didSelectRowAt inIndexPath: IndexPath) {
        (delegate as? RVS_AutofillTextFieldDelegate)?.autoFillTextField(self, selectionWasMade: _currentAutoFill[inIndexPath.row])
        inTableView.deselectRow(at: inIndexPath, animated: true)
        guard let textValue = tableView(inTableView, cellForRowAt: inIndexPath).textLabel?.text,
              !textValue.isEmpty
        else { return }
        text = textValue
        sendActions(for: .editingChanged)
        closeTableViewAndResignFirstResponder()
    }
}

/* ###################################################################################################################################### */
// MARK: - Data Type
// MARK: One Element of the Data Source Array -
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
    public let value: String

    /* ################################################################## */
    /**
     This is an arbitrary associated data type. It can be anything, and will be associated with the String value. It should be noted that this will be a strong reference to classes.
     */
    public let refCon: Any?
    
    /* ################################################################## */
    /**
     Standard initializer
     
     - parameter value: Required (and must be non-blank). The String value.
     - parameter refCon: Optional (default is nil). This is an arbitrary data item that is associated with this instance. It should be noted that this will be a strong reference to classes.
     */
    public init(value inValue: String, refCon inRefCon: Any? = nil) {
        precondition(!inValue.isEmpty, "Value Must Be Non-Blank!")
        value = inValue
        refCon = inRefCon
    }
}

/* ###################################################################################################################################### */
// MARK: CustomDebugStringConvertible Conformance
/* ###################################################################################################################################### */
extension RVS_AutofillTextFieldDataSourceType: CustomDebugStringConvertible {
    /* ################################################################## */
    /**
     This gives us a debug display.
     */
    public var debugDescription: String { "RVS_AutofillTextFieldDataSourceType {\n\tvalue: \"\(value)\"\n\trefCon: \(String(describing: refCon))\n}" }
}

/* ###################################################################################################################################### */
// MARK: CustomStringConvertible Conformance
/* ###################################################################################################################################### */
extension RVS_AutofillTextFieldDataSourceType: CustomStringConvertible {
    /* ################################################################## */
    /**
     This gives us a simple display.
     */
    public var description: String { "RVS_AutofillTextFieldDataSourceType(value: \"\(value)\", refCon: \(String(describing: refCon)))" }
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
// MARK: - Published Protocols
// MARK: Data Source Protocol -
/* ###################################################################################################################################### */
/**
 The text field class will require that it be connected to a data source, which is an instance of a class, struct, or enum that conforms to this protocol.
 It will supply the data to be displayed in the autofill table.
 If the data source does not supply any data, then the text field acts just like any other text field.
 */
public protocol RVS_AutofillTextFieldDataSource {
    /* ################################################################## */
    /**
     This is an Array of structs, that are the searchable data collection for the text field.
     You can leave this undefined in your conformance, as the `getTextDictionaryFromThis` method is all that is necessary to supply the searchable Array.
     If you are using the default implementation of `getTextDictionaryFromThis`, then you **MUST** provide your own version of this Array.
     However, if you do leave this undefined, then you **MUST** implement your own version of `getTextDictionaryFromThis`.
     If this is not implemented, or is empty, and there is no custom implementation of `getTextDictionaryFromThis`, then no searches will return any results.
     */
    var textDictionary: [RVS_AutofillTextFieldDataSourceType] { get }
    
    /* ################################################################## */
    /**
     This searches the Array, for strings that match the given String, according to the parameters included with the invocation.
     If you do leave `textDictionary` undefined, then you **MUST** implement your own version of this method.
     The protocol default does a rather naive comparison that is likely to be sufficient for most purposes (which requires that you implement `textDictionary`).
     - parameter string: The String to search for
     - parameter isCaseSensitive: False, by default. If true, the String must match case, as well as content.
     - parameter isWildcardBefore: False, by default. If true, then the String can be preceded by other characters. If false, the given String must start the value being tested.
     - parameter isWildcardAfter: True, by default. If true, then the String can be followed by other characters. If false, the given String must end the value being tested.
     - parameter maximumAutofillCount: 5, by default. This is the maximum number of results to return. The return can contain fewer elements. If -1, then there is no limit.
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
     If you are using the default implementation of `getTextDictionaryFromThis`, then you **MUST** provide your own version of this Array.
     */
    public var textDictionary: [RVS_AutofillTextFieldDataSourceType] { [] }
    
    /* ################################################################## */
    /**
     Default uses the Array extension subscripts to search the Array.
     If you do leave `textDictionary` undefined, then you **MUST** implement your own version of this method.
     We have some defaults:
     
        - isCaseSensitive: false
        - isWildcardBefore: false
        - isWildcardAfter: true
        - maximumAutofillCount: 5
     
     The String is required.
     */
    public func getTextDictionaryFromThis(string inString: String,
                                          isCaseSensitive inIsCaseSensitive: Bool = RVS_AutofillTextField.defaultIsCaseSensitive,
                                          isWildcardBefore inIsWildcardBefore: Bool = RVS_AutofillTextField.defaultIsWildcardBefore,
                                          isWildcardAfter inIsWildcardAfter: Bool = RVS_AutofillTextField.defaultIsWildcardAfter,
                                          maximumAutofillCount inMaximumAutofillCount: Int = RVS_AutofillTextField.defaultMaximumCount
    ) -> [RVS_AutofillTextFieldDataSourceType] {
        
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
        
        return [RVS_AutofillTextFieldDataSourceType](ret[0..<max(0, min(ret.count, 0 <= inMaximumAutofillCount ? inMaximumAutofillCount : ret.count))])
    }
}

/* ###################################################################################################################################### */
// MARK: - Delegate Protocol -
/* ###################################################################################################################################### */
/**
 We add methods specific to this class.
 */
public protocol RVS_AutofillTextFieldDelegate: AnyObject {
    /* ################################################################## */
    /**
     This is called when the user makes a selection, and the text is entered into the field.
     It allows you to access the refCon of the selected completion.
     
     - parameter autofillTextField: The text field affected.
     - parameter selectionWasMade: This is the complete data source entity that was selected.
     */
    func autoFillTextField(_ autofillTextField: RVS_AutofillTextField, selectionWasMade: RVS_AutofillTextFieldDataSourceType)
}

/* ###################################################################################################################################### */
// MARK: Defaults
/* ###################################################################################################################################### */
extension RVS_AutofillTextFieldDelegate {
    /* ################################################################## */
    /**
     Default does nothing.
     */
    public func autoFillTextField(_: RVS_AutofillTextField, selectionWasMade: RVS_AutofillTextFieldDataSourceType) { }
}

/* ###################################################################################################################################### */
// MARK: - ##############################################################################
// MARK: Internal Use Only
// MARK: Fileprivate Array Extension, for Getting Values by Key -
/* ###################################################################################################################################### */
/**
 This Array extension adds some fairly basic subscript specializations, that allow the match testing to happen.
 */
fileprivate extension Array where Element == RVS_AutofillTextFieldDataSourceType {
    /* ################################################################## */
    /**
     This looks for a substring inside another string.
     
     This is a very "greedy" and simple search. It simply moves forward, through the text, until the first substring match, and returns the range of that substring.
     
     - parameter inSubString: This is the String to look for (needle).
     - parameter inInThisString: This is the String to look inside (haystack).
     - parameter isCaseSensitive: Default is false. If true, then the match needs to take case and diacriticals into account. If false, diacriticals are also ignored.
     - returns: A String Index range (just one). May be nil or empty.
     */
    private static func _getRangeOf(_ inSubString: String, inThisString inInThisString: String, isCaseSensitive inIsCaseSensitive: Bool = false) -> Range<String.Index>? {
        inInThisString.range(of: inSubString, options: String.CompareOptions(inIsCaseSensitive ? [.literal] : [.caseInsensitive, .diacriticInsensitive]))
    }
    
    /* ################################################################## */
    /**
     This looks for an exact match. It can be case-blind (by default).
     
     - parameter is: This is the String to test against. The entire value must match, but can be case-blind.
     - parameter isCaseSensitive: Default is false. If true, then the match needs to take case into account.
     - returns: An Array of all elements that match.
     */
    subscript(is inKey: String, isCaseSensitive inIsCaseSensitive: Bool = false) -> [RVS_AutofillTextFieldDataSourceType] {
        return compactMap {
            let searchRange = Self._getRangeOf(inKey, inThisString: $0.value, isCaseSensitive: inIsCaseSensitive)
            if !(searchRange?.isEmpty ?? true),
               $0.value.startIndex == searchRange?.lowerBound,
               $0.value.endIndex == searchRange?.upperBound {
                return $0
            }
            
            return nil
        }
    }
    
    /* ################################################################## */
    /**
     This looks for a string that is "wildcarded" in front, but ends with the exact String. It can be case-blind (by default).
     
     - parameter endsWith: This is the String to test against. The entire value must match (but can be preceded by other characters), but can be case-blind.
     - parameter isCaseSensitive: Default is false. If true, then the match needs to take case into account.
     - returns: An Array of all elements that match.
     */
    subscript(endsWith inKey: String, isCaseSensitive inIsCaseSensitive: Bool = false) -> [RVS_AutofillTextFieldDataSourceType] {
        return compactMap {
            let searchRange = Self._getRangeOf(inKey, inThisString: $0.value, isCaseSensitive: inIsCaseSensitive)
            if !(searchRange?.isEmpty ?? true),
               $0.value.endIndex == searchRange?.upperBound {
                return $0
            }
            
            return nil
        }
    }
    
    /* ################################################################## */
    /**
     This looks for a string that is "wildcarded" after, but begins with the exact String. It can be case-blind (by default).
     
     - parameter beginsWith: This is the String to test against. The entire value must match (but can be followed by other characters), but can be case-blind.
     - parameter isCaseSensitive: Default is false. If true, then the match needs to take case into account.
     - returns: An Array of all elements that match.
     */
    subscript(beginsWith inKey: String, isCaseSensitive inIsCaseSensitive: Bool = false) -> [RVS_AutofillTextFieldDataSourceType] {
        return compactMap {
            let searchRange = Self._getRangeOf(inKey, inThisString: $0.value, isCaseSensitive: inIsCaseSensitive)
            if !(searchRange?.isEmpty ?? true),
               $0.value.startIndex == searchRange?.lowerBound {
                return $0
            }
            
            return nil
        }
    }
    
    /* ################################################################## */
    /**
     This lsees if the element contains the exact String. It can be case-blind (by default).
     
     - parameter contains: This is the String to test against. The entire value must match (but can be preceded and followed by other characters), but can be case-blind.
     - parameter isCaseSensitive: Default is false. If true, then the match needs to take case into account.
     - returns: An Array of all elements that match.
     */
    subscript(contains inKey: String, isCaseSensitive inIsCaseSensitive: Bool = false) -> [RVS_AutofillTextFieldDataSourceType] {
        compactMap({ !(Self._getRangeOf(inKey, inThisString: $0.value, isCaseSensitive: inIsCaseSensitive)?.isEmpty ?? true) ? $0 : nil })
    }
}
