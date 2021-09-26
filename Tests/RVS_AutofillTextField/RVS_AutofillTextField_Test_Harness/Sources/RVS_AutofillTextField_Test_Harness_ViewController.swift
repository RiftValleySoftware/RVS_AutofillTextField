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
import RVS_GeneralObserver
import RVS_Checkbox

/* ###################################################################################################################################### */
// MARK: - UIView Extension -
/* ###################################################################################################################################### */
/**
 We can round the corners, and add auto-layout-prescribed views.
 */
extension UIView {
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
/* ###################################################################################################################################### */
/**
 
 */
class RVS_AutofillTextField_Test_Harness_ViewController_TableCell: UITableViewCell, RVS_GeneralObservableProtocol {
    /* ################################################################## */
    /**
     */
    static let textCellReuseID = "sample-text-cell"
    
    /* ################################################################## */
    /**
     */
    var uuid: UUID = UUID()
    
    /* ################################################################## */
    /**
     */
    var observers: [RVS_GeneralObserverProtocol] = []
    
    /* ################################################################## */
    /**
     */
    var index: Int = -1
    
    /* ################################################################## */
    /**
     */
    @IBOutlet var sampleTextField: UITextField!
}

/* ###################################################################################################################################### */
/* ###################################################################################################################################### */
extension RVS_AutofillTextField_Test_Harness_ViewController_TableCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        sampleTextField?.addTarget(self, action: #selector(_textHasChanged(_:)), for: .editingChanged)
    }
}

/* ###################################################################################################################################### */
/* ###################################################################################################################################### */
extension RVS_AutofillTextField_Test_Harness_ViewController_TableCell {
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
/* ###################################################################################################################################### */
/**
 
 */
class RVS_AutofillTextField_Test_Harness_ViewController: UIViewController, RVS_GeneralObserverProtocol {
    /* ################################################################## */
    /**
     */
    var uuid: UUID = UUID()
    
    /* ################################################################## */
    /**
     This will contain the strings that we will use for comparison.
     */
    var currentTextDictionary: [String] = [ "How now, brown cow?",
                                            "Mrs. O'Leary's Cow",
                                            "The large print giveth, and the small print taketh away.",
                                            "Cow Harbor",
                                            "cow harbor",
                                            "COW HARBOR",
                                            "A Rhino is A Large Horned Ungulate.",
                                            "A rhino is not a cow, however.",
                                            "Neither is a steer.",
                                            "What about a bison?",
                                            "Seacows are seals.",
                                            "Buffalo Buffalo Buffalo Buffalo Buffalo",
                                            "The quick brown fox jumped over the lazy dog.",
                                            "Today's cow is tomorrow's burger.",
                                            "Today's COW is tomorrow's burger.",
                                            "WHOLLY COW",
                                            "Holy COW",
                                            "Holy cow",
                                            "holly cow",
                                            "Holy cow, Batman!"
    ]
        
    /* ################################################################## */
    /**
     */
    @IBOutlet weak var autofillTextField: RVS_AutofillTextField!
    
    /* ################################################################## */
    /**
     */
    @IBOutlet weak var sampleTable: UITableView!
    
    /* ################################################################## */
    /**
     */
    @IBOutlet weak var isOnCheckbox: RVS_Checkbox!
    
    /* ################################################################## */
    /**
     */
    @IBOutlet weak var isWildcardBeforeCheckbox: RVS_Checkbox!

    /* ################################################################## */
    /**
     */
    @IBOutlet weak var isWildcardAfterCheckbox: RVS_Checkbox!
    
    /* ################################################################## */
    /**
     */
    @IBOutlet weak var isCaseSensitiveCheckbox: RVS_Checkbox!

    /* ################################################################## */
    /**
     */
    @IBOutlet weak var maximumResultCount: UITextField!
}

/* ###################################################################################################################################### */
/* ###################################################################################################################################### */
extension RVS_AutofillTextField_Test_Harness_ViewController {
    /* ################################################################## */
    /**
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
     Called to close the keyboard.
     
     - parameter: ignored (can also be omitted)
     */
    @IBAction func closeKeyboard(_: Any! = nil) {
        #if DEBUG
            print("Closing the keyboard.")
        #endif
        autofillTextField?.resignFirstResponder()
    }
}

/* ###################################################################################################################################### */
/* ###################################################################################################################################### */
extension RVS_AutofillTextField_Test_Harness_ViewController: RVS_AutofillTextFieldDataSource {
    /* ################################################################## */
    /**
     This is an Array of structs, that are the searchable data collection for the text field.
     If this is empty, then no searches will return any results.
     */
    var textDictionary: [RVS_AutofillTextFieldDataSourceType] {
        currentTextDictionary.compactMap {
            let currentStr = $0.trimmingCharacters(in: .whitespacesAndNewlines)
            return !currentStr.isEmpty ? RVS_AutofillTextFieldDataSourceType(value: currentStr) : nil
        }
    }
}

/* ###################################################################################################################################### */
/* ###################################################################################################################################### */
extension RVS_AutofillTextField_Test_Harness_ViewController {
    /* ################################################################## */
    /**
     */
    func textChanged(_ inText: String, row inRow: Int) {
        currentTextDictionary[inRow] = inText
    }
    
    /* ################################################################## */
    /**
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
     */
    @IBAction func maximumCountChanged(_ inSender: UITextField) {
        autofillTextField?.maximumAutofillCount = Int(inSender.text ?? "0") ?? 0
    }
}

/* ###################################################################################################################################### */
/* ###################################################################################################################################### */
extension RVS_AutofillTextField_Test_Harness_ViewController: UITableViewDataSource {
    /* ################################################################## */
    /**
     */
    func tableView(_ inTableView: UITableView, numberOfRowsInSection inSection: Int) -> Int { currentTextDictionary.count }
    
    /* ################################################################## */
    /**
     */
    func tableView(_ inTableView: UITableView, cellForRowAt inIndexPath: IndexPath) -> UITableViewCell {
        if let ret = inTableView.dequeueReusableCell(withIdentifier: RVS_AutofillTextField_Test_Harness_ViewController_TableCell.textCellReuseID, for: inIndexPath) as? RVS_AutofillTextField_Test_Harness_ViewController_TableCell {
            ret.subscribe(self)
            if currentTextDictionary.count > inIndexPath.row {
                ret.index = inIndexPath.row
                ret.sampleTextField?.text = currentTextDictionary[inIndexPath.row]
            }
            return ret
        } else {
            return UITableViewCell()
        }
    }
}
