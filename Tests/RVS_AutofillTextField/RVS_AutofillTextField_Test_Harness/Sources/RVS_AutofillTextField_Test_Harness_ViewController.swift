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
    @IBOutlet var sampleTextField: UITextField!
}

/* ###################################################################################################################################### */
/* ###################################################################################################################################### */
/**
 
 */
class RVS_AutofillTextField_Test_Harness_ViewController: UIViewController, RVS_GeneralObserverProtocol, RVS_AutofillTextFieldDataSource {
    /* ################################################################## */
    /**
     */
    var uuid: UUID = UUID()
    
    /* ################################################################## */
    /**
     This is an Array of structs, that are the searchable data collection for the text field.
     If this is empty, then no searches will return any results.
     */
    var textDictionary: [RVS_AutofillTextFieldDataSourceType] = []

    /* ################################################################## */
    /**
     */
    @IBOutlet var autofillTextField: RVS_AutofillTextField!
    
    /* ################################################################## */
    /**
     */
    @IBOutlet var sampleTable: UITableView!

    /* ################################################################## */
    /**
     */
    override func viewDidLoad() {
        super.viewDidLoad()
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
extension RVS_AutofillTextField_Test_Harness_ViewController: UITableViewDataSource {
    /* ################################################################## */
    /**
     */
    func tableView(_ inTableView: UITableView, numberOfRowsInSection inSection: Int) -> Int { 100 }
    
    /* ################################################################## */
    /**
     */
    func tableView(_ inTableView: UITableView, cellForRowAt inIndexPath: IndexPath) -> UITableViewCell {
        if let ret = inTableView.dequeueReusableCell(withIdentifier: RVS_AutofillTextField_Test_Harness_ViewController_TableCell.textCellReuseID, for: inIndexPath) as? RVS_AutofillTextField_Test_Harness_ViewController_TableCell {
            ret.subscribe(self)
            
            return ret
        } else {
            return UITableViewCell()
        }
    }
}
