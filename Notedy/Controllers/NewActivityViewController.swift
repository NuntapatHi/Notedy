//
//  NewActivityViewController.swift
//  Notedy
//
//  Created by Nuntapat Hirunnattee on 30/7/2565 BE.
//

import UIKit
import RealmSwift

class NewActivityViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var detailTextField: UITextField!
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    let realm = try! Realm()
    let picker = UIDatePicker()
    var tempTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New Activity"
        
        dateTextField.delegate = self
        timeTextField.delegate = self
        titleTextField.delegate = self
        
        dateTextField.text = formatDate(date: Date(), mode: .date)
        timeTextField.text = formatDate(date: Date(), mode: .time)
        
        picker.frame.size = CGSize(width: 0, height: 300)
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "TH")
        
    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        if titleTextField.text != ""{
            saveActivity()
        } else {
            let alert = UIAlertController(title: "Alert", message: "Title cannot be empty.", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
//MARK: - Data Data Manipulation Methods
    func saveActivity(){
        
        let newActivity = Activity()
        
        newActivity.title = titleTextField.text!
        
        if let location = locationTextField.text{
            newActivity.location = location
        }
        
        if let detail = detailTextField.text{
            newActivity.detail = detail
        }
        
        newActivity.time = timeTextField.text!
        newActivity.date = dateTextField.text!
        
        do{
            try realm.write {
                realm.add(newActivity)
                navigationController?.popViewController(animated: true)
            }
        } catch {
            print("Error saving data. \(error)")
        }
    }
}


//MARK: - TextFieldDelegate Methods
extension NewActivityViewController: UITextFieldDelegate{
        
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dateTextField{
            openDatePicker(with: textField, mode: .date)
        }
        if textField == timeTextField{
            openDatePicker(with: textField, mode: .time)
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        //open datePicker with valued textField
        let dateFormatter = DateFormatter()
        if textField == dateTextField{
            dateFormatter.dateStyle = .medium
            picker.date = dateFormatter.date(from: textField.text!)!
        }
        
        if textField == timeTextField{
            dateFormatter.dateFormat = "HH:mm"
            picker.date = dateFormatter.date(from: textField.text!)!
        }
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == titleTextField{
            return true
        } else {
            return false
        }
    }
}

//MARK: - DatePicker
extension NewActivityViewController{
    
    func openDatePicker(with textField: UITextField, mode: UIDatePicker.Mode){
        tempTextField = textField
        picker.datePickerMode = mode
        picker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        textField.inputView = picker
        textField.inputAccessoryView = setUpToolBar()
    }

    
    @objc func dateChange(datePicker: UIDatePicker){
        tempTextField.text = formatDate(date: datePicker.date, mode: datePicker.datePickerMode)
    }
    
    func formatDate(date: Date, mode: UIDatePicker.Mode) -> String{
        let formatter = DateFormatter()
        if mode == .date{
            formatter.dateStyle = .medium
        }
        if mode == .time{
            formatter.dateFormat = "HH:mm"
        }
        return formatter.string(from: date)
    }
}




//MARK: - ToolBar
extension NewActivityViewController{
    
    func setUpToolBar() -> UIToolbar{
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 45))
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelBtnPressed))
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneBtnPressed))
        let flexibelBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelBtn, flexibelBtn, doneBtn], animated: false)
        toolBar.barTintColor = UIColor(named: "PrimaryColor")
        return toolBar
    }
    
    @objc func cancelBtnPressed(){
        tempTextField.resignFirstResponder()
        tempTextField = UITextField()
    }
    
    @objc func doneBtnPressed(){
        if let datePicker = tempTextField.inputView as? UIDatePicker{
            tempTextField.text = formatDate(date: datePicker.date, mode: datePicker.datePickerMode)
            tempTextField = UITextField()
        }
        view.endEditing(true)
    }
}

