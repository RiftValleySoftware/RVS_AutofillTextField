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
import RVS_GeneralObserver
import RVS_Checkbox
import RVS_AutofillTextField

/* ###################################################################################################################################### */
// MARK: - UIView Extension -
/* ###################################################################################################################################### */
/**
 We can round the corners, and add auto-layout-prescribed views.
 */
fileprivate extension UIView {
    /* ################################################################## */
    /**
     This gives us access to the corner radius, so we can give the view rounded corners.
     
     > **NOTE:** This requires that `clipsToBounds` be set.
     */
    @IBInspectable var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            setNeedsDisplay()
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - Custom Table Cell Class With Editable Display -
/* ###################################################################################################################################### */
/**
 We use a custom table cell view, so we can have the text be editable.
 */
class RVS_AutofillTextField_Test_Harness_ViewController_TableCell: UITableViewCell, RVS_GeneralObservableProtocol {
    /* ################################################################## */
    /**
     The reuse ID for this class.
     */
    static let textCellReuseID = "sample-text-cell"
    
    /* ################################################################## */
    /**
     This is for `RVS_GeneralObservableProtocol` conformance. We never use it, ourselves.
     */
    var uuid: UUID = UUID()
    
    /* ################################################################## */
    /**
     This is also for `RVS_GeneralObservableProtocol` conformance, but we do use this.
     This is an Array that has all our subscribers listed.
     */
    var observers: [RVS_GeneralObserverProtocol] = []
    
    /* ################################################################## */
    /**
     This will return the data Array/table row index that corresponds to this instance.
     */
    var index: Int = -1
    
    /* ################################################################## */
    /**
     This is an editable text field, so we can change the sample text.
     */
    @IBOutlet var sampleTextField: UITextField!
}

/* ###################################################################################################################################### */
// MARK: Base Class Overrides
/* ###################################################################################################################################### */
extension RVS_AutofillTextField_Test_Harness_ViewController_TableCell {
    /* ################################################################## */
    /**
     Called when the layout happens. We use this to subscribe to the text field, for editing changes.
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        sampleTextField?.addTarget(self, action: #selector(_textHasChanged(_:)), for: .editingChanged)
    }
}

/* ###################################################################################################################################### */
// MARK: Callbacks
/* ###################################################################################################################################### */
extension RVS_AutofillTextField_Test_Harness_ViewController_TableCell {
    /* ################################################################## */
    /**
     Called when text in the editable text field changes. We broadcast the new text to the observers.
     - parameter inTextField: The text field that was changed.
     */
    @objc private func _textHasChanged(_ inTextField: UITextField) {
        observers.forEach {
            if let observer = $0 as? RVS_AutofillTextField_Test_Harness_ViewController,
               let text = inTextField.text,
               -1 < index {
                observer.textChanged(text, row: self.index)
            }
        }
    }
}

/* ###################################################################################################################################### */
// MARK: - The Main Test Harness Screen View Controller -
/* ###################################################################################################################################### */
/**
 The test harness app is a very simple app, with only one screen. This screen presents a "dashboard" to test the edit text field.
 */
class RVS_AutofillTextField_Test_Harness_ViewController: UIViewController, RVS_GeneralObserverProtocol {
    /* ################################################################## */
    /**
     `RVS_GeneralObserverProtocol` conformance.
     This is never used by the class. It is here for the observer relationship management.
     */
    var uuid: UUID = UUID()
    
    /* ################################################################## */
    /**
     This will contain the strings that we will use for comparison. They will be in the table, below the "dashboard."
     */
    var testingTextDictionary: [String] = [ "How now, brown cow?",
                                            "Mrs. O'Leary's Cow",
                                            "The large print giveth, and the small print taketh away.",
                                            "Cow Harbor",
                                            "cow harbor",
                                            "çow harbor",
                                            "çöé harbor",
                                            "COW HARBOR",
                                            "Kow Harbour",
                                            "A Rhino is A Large Horned Ungulate.",
                                            "A rhino is not a cow, however.",
                                            "Neither is a steer.",
                                            "Seacows are seals.",
                                            "So are sea lions.",
                                            "What about a bison?",
                                            "Buffalo Buffalo Buffalo Buffalo Buffalo",
                                            "The quick brown fox jumped over the lazy dog.",
                                            "Tomorrow's COW is yesterday's calf.",
                                            "Today's cow is tomorrow's burger.",
                                            "oberman",
                                            "öberman",
                                            "Öberman",
                                            "here's my resume",
                                            "here's my résumé",
                                            "MY RÉSUMÉ",
                                            "Héré is my RÉSUMÉ. I høpe Ü like it.",
                                            "WHOLLY COW",
                                            "Holy COW",
                                            "Holy cow",
                                            "holly cow",
                                            "holy çow",
                                            "holly kow",
                                            "Holy cow, Batman!",
                                            "What is Gary Larsen's favorite critter?",
                                            "What is it, with you and cows, anyway?"
    ]
    
    /* ################################################################## */
    /**
     This contains color combinations that are applied for various values of the segmented switch.
     */
    var segmentColorThemeValues: [(backgroundColor: UIColor, textColor: UIColor)] = [
        (backgroundColor: .systemBackground.withAlphaComponent(0.75), textColor: .label),   // Use whatever the system decides.
        (backgroundColor: .white.withAlphaComponent(0.75), textColor: .black),              // Force a light appearance
        (backgroundColor: .black.withAlphaComponent(0.75), textColor: .white),              // Force a dark appearance
        (backgroundColor: .systemRed.withAlphaComponent(0.75), textColor: .yellow)          // MY EYES MY EYES
    ]
        
    /* ################################################################## */
    /**
     This is the CuT (Code Under Test). It is the test target instance of `RVS_AutofillTextField`.
     */
    @IBOutlet weak var autofillTextField: RVS_AutofillTextField!
    
    /* ################################################################## */
    /**
     This is a table of editable text entities. It has the strings that appear in the dropdown.
     */
    @IBOutlet weak var sampleTable: UITableView!
    
    /* ################################################################## */
    /**
     This checkbox is the main "circuit breaker." If it is off (default is on), then the text field will be just a text field.
     */
    @IBOutlet weak var isOnCheckbox: RVS_Checkbox!

    /* ################################################################## */
    /**
     If this checkbox is on (default is on), then we will ignore non-matching characters after the match.
     */
    @IBOutlet weak var isWildcardAfterCheckbox: RVS_Checkbox!
    
    /* ################################################################## */
    /**
     If this checkbox is on (default is off), then we will ignore non-matching characters leading up to the match.
     */
    @IBOutlet weak var isWildcardBeforeCheckbox: RVS_Checkbox!

    /* ################################################################## */
    /**
     If this checkbox is on (default is off), then case and diacriticals will be counted in the match.
     */
    @IBOutlet weak var isCaseSensitiveCheckbox: RVS_Checkbox!

    /* ################################################################## */
    /**
     This is the maximum number of results edit field. If set to -1, then we will display all possible matches in the dropdown.
     */
    @IBOutlet weak var maximumResultCount: UITextField!

    /* ################################################################## */
    /**
     This control allows us to select an explicit "color theme" for the text field.
     */
    @IBOutlet weak var colorSegmentedControl: UISegmentedControl!
}

/* ###################################################################################################################################### */
// MARK: Base Class Overrides
/* ###################################################################################################################################### */
extension RVS_AutofillTextField_Test_Harness_ViewController {
    /* ################################################################## */
    /**
     Called when the view hierarchy has been loaded. We use this to sync the CuT with the UX.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        autofillTextField?.dataSource = self
        autofillTextField?.isAutoFillOn = isOnCheckbox?.isOn ?? false
        autofillTextField?.isWildcardBefore = isWildcardBeforeCheckbox?.isOn ?? false
        autofillTextField?.isWildcardAfter = isWildcardAfterCheckbox?.isOn ?? false
        autofillTextField?.isCaseSensitive = isCaseSensitiveCheckbox?.isOn ?? false
        autofillTextField?.maximumAutofillCount = Int(maximumResultCount?.text ?? "0") ?? 0
    }
    
    /* ################################################################## */
    /**
     This sets the color theme, according to the segmented switch.
     */
    func selectColorTheme() {
        let selectedColorTheme = segmentColorThemeValues[colorSegmentedControl?.selectedSegmentIndex ?? 0]
        
        autofillTextField?.tableBackgroundColor = selectedColorTheme.backgroundColor
        autofillTextField?.tableTextColor = selectedColorTheme.textColor
    }
}

/* ###################################################################################################################################### */
// MARK: RVS_AutofillTextFieldDataSource Conformance
/* ###################################################################################################################################### */
extension RVS_AutofillTextField_Test_Harness_ViewController: RVS_AutofillTextFieldDataSource {
    /* ################################################################## */
    /**
     This is an Array of structs, that are the searchable data collection for the text field.
     If this is empty, then no searches will return any results.
     */
    var textDictionary: [RVS_AutofillTextFieldDataSourceType] {
        testingTextDictionary.compactMap {
            let currentStr = $0.trimmingCharacters(in: .whitespacesAndNewlines)
            return !currentStr.isEmpty ? RVS_AutofillTextFieldDataSourceType(value: currentStr) : nil
        }
    }
}

/* ###################################################################################################################################### */
// MARK: Callbacks
/* ###################################################################################################################################### */
extension RVS_AutofillTextField_Test_Harness_ViewController {
    /* ################################################################## */
    /**
     Called to close the keyboard.
     
     - parameter: ignored (can also be omitted)
     */
    @IBAction func closeKeyboard(_: Any! = nil) {
        #if DEBUG
            print("Closing the keyboard.")
        #endif
        autofillTextField?.resignFirstResponder()
    }
    
    /* ################################################################## */
    /**
     Called when either the checkbox changes state, or its associated label button is hit (toggles the value).
     - parameter inSender: The instance that triggered this. It is either an instance of `RVS_Checkbox`, or UIButton (the label).
     */
    @IBAction func isOnChanged(_ inSender: Any) {
        if let sender = inSender as? RVS_Checkbox {
            autofillTextField?.isAutoFillOn = sender.isOn
        } else {
            isOnCheckbox?.setOn(!(isOnCheckbox?.isOn ?? true), animated: true)
            isOnCheckbox?.sendActions(for: .valueChanged)
        }
    }
    
    /* ################################################################## */
    /**
     Called when either the checkbox changes state, or its associated label button is hit (toggles the value).
     - parameter inSender: The instance that triggered this. It is either an instance of `RVS_Checkbox`, or UIButton (the label).
     */
    @IBAction func wildcardAfterChanged(_ inSender: Any) {
        if let sender = inSender as? RVS_Checkbox {
            autofillTextField?.isWildcardAfter = sender.isOn
        } else {
            isWildcardAfterCheckbox?.setOn(!(isWildcardAfterCheckbox?.isOn ?? true), animated: true)
            isWildcardAfterCheckbox?.sendActions(for: .valueChanged)
        }
    }

    /* ################################################################## */
    /**
     Called when either the checkbox changes state, or its associated label button is hit (toggles the value).
     - parameter inSender: The instance that triggered this. It is either an instance of `RVS_Checkbox`, or UIButton (the label).
     */
    @IBAction func wildcardBeforeChanged(_ inSender: Any) {
        if let sender = inSender as? RVS_Checkbox {
            autofillTextField?.isWildcardBefore = sender.isOn
        } else {
            isWildcardBeforeCheckbox?.setOn(!(isWildcardBeforeCheckbox?.isOn ?? true), animated: true)
            isWildcardBeforeCheckbox?.sendActions(for: .valueChanged)
        }
    }

    /* ################################################################## */
    /**
     Called when either the checkbox changes state, or its associated label button is hit (toggles the value).
     - parameter inSender: The instance that triggered this. It is either an instance of `RVS_Checkbox`, or UIButton (the label).
     */
    @IBAction func caseSensitiveChanged(_ inSender: Any) {
        if let sender = inSender as? RVS_Checkbox {
            autofillTextField?.isCaseSensitive = sender.isOn
        } else {
            isCaseSensitiveCheckbox?.setOn(!(isCaseSensitiveCheckbox?.isOn ?? true), animated: true)
            isCaseSensitiveCheckbox?.sendActions(for: .valueChanged)
        }
    }

    /* ################################################################## */
    /**
     Called when either the checkbox changes state, or its associated label button is hit (toggles the value).
     - parameter inSender: The instance that triggered this. It is either an instance of `RVS_Checkbox`, or UIButton (the label).
     */
    @IBAction func maximumCountChanged(_ inSender: UITextField) {
        autofillTextField?.maximumAutofillCount = Int(inSender.text ?? "0") ?? 0
    }

    /* ################################################################## */
    /**
     Called when the "color theme" has changed.
     
     - parameter inSegmentedControl: The segmented control that changed.
     */
    @IBAction func colorSegmentedControlChanged(_ inSegmentedControl: UISegmentedControl) {
        selectColorTheme()
    }

    /* ################################################################## */
    /**
     Called when text changes in one of the table rows. This is an observer callback, from the table rows.
     
     - parameter inText: The new text.
     - parameter row: The 0-based row index of the changed text
     */
    func textChanged(_ inText: String, row inRow: Int) {
        testingTextDictionary[inRow] = inText
    }
}

/* ###################################################################################################################################### */
// MARK: UITableViewDataSource Conformance
/* ###################################################################################################################################### */
extension RVS_AutofillTextField_Test_Harness_ViewController: UITableViewDataSource {
    /* ################################################################## */
    /**
     This just tells the table how many rows to display.
     
     - parameter inTableView: The table view instance.
     - parameter numberOfRowsInSection: The 0-based section index (always ignored).
     - returns: The number of strings to display.
     */
    func tableView(_ inTableView: UITableView, numberOfRowsInSection: Int) -> Int { testingTextDictionary.count }
    
    /* ################################################################## */
    /**
     This creates one row for our test string table.
     
     - parameter inTableView: The table view instance.
     - parameter cellForRowAt: The 0-based cell index (section is ignored, and assumed to be 0).
     - returns: A new table row instance.
     */
    func tableView(_ inTableView: UITableView, cellForRowAt inIndexPath: IndexPath) -> UITableViewCell {
        if let ret = inTableView.dequeueReusableCell(withIdentifier: RVS_AutofillTextField_Test_Harness_ViewController_TableCell.textCellReuseID, for: inIndexPath) as? RVS_AutofillTextField_Test_Harness_ViewController_TableCell {
            ret.subscribe(self)
            if testingTextDictionary.count > inIndexPath.row {
                ret.index = inIndexPath.row
                ret.sampleTextField?.text = testingTextDictionary[inIndexPath.row]
            }
            return ret
        } else {
            return UITableViewCell()
        }
    }
}
