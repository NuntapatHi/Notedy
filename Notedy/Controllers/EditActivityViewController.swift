//
//  EditActivityViewController.swift
//  Notedy
//
//  Created by Nuntapat Hirunnattee on 6/8/2565 BE.
//

import UIKit
import RealmSwift
import SwiftUI
class EditActivityViewController: UIViewController {
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var timeTF: UITextField!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var detailTF: UITextField!
    
    let realm = try! Realm()
    var selectedActivity: Activity?
    let picker = UIDatePicker()
    var tempTextField = UITextField()
    var pickerMode: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Edit Activity"
        
        dateTF.delegate = self
        timeTF.delegate = self
        
        //set up selected activity
        titleTF.text = selectedActivity?.title
        locationTF.text = selectedActivity?.location
        timeTF.text = selectedActivity?.time
        dateTF.text = selectedActivity?.date
        detailTF.text = selectedActivity?.detail

        picker.frame.size = CGSize(width: 0, height: 300)
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "th")
    }
    
//MARK: - Button Actions
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        if titleTF.text != ""{
            updateActivity()
        } else {
            let alert = UIAlertController(title: "Alert", message: "Title cannot be empty.", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Confirmation", message: "Are you sure to delete this activity?", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "OK", style: .default) { confirm in
            self.deleteActivity()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
//MARK: - CRUD
    func updateActivity(){
        do{
            try realm.write {
                selectedActivity?.title = titleTF.text!
                
                if let location = locationTF.text{
                    selectedActivity?.location = location
                }
                selectedActivity?.time = timeTF.text!
                selectedActivity?.date = dateTF.text!
                if let detail = detailTF.text{
                    selectedActivity?.detail = detail
                }
                print("Update sucessed")
                
                navigationController?.popViewController(animated: true)
            }
        } catch {
            print("Error update data, \(error)")
        }
    }
    
    func deleteActivity(){
        do{
            try realm.write {
                realm.delete(selectedActivity!)
                navigationController?.popViewController(animated: true)
            }
        } catch {
            print("Error delete data. \(error)")
        }
    }
}

//MARK: - TextField Delegate
extension EditActivityViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dateTF{
            openDatePicker(with: textField)
        }
        if textField == timeTF{
            openTimePicker(with: textField)
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        //open datePicker with valued textField
        let dateFormatter = DateFormatter()
        if textField == dateTF{
            dateFormatter.dateStyle = .medium
            picker.date = dateFormatter.date(from: textField.text!)!
        }
        
        if textField == timeTF{
            dateFormatter.dateFormat = "HH:mm"
            picker.date = dateFormatter.date(from: textField.text!)!
        }
        return true
    }
}
//MARK: - DatePicker
extension EditActivityViewController{

    func openDatePicker(with textField: UITextField){
        tempTextField = textField
        picker.datePickerMode = .date
        pickerMode = "date"
        picker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        textField.inputView = picker
        textField.inputAccessoryView = setUpToolBar()
    }
    
    func openTimePicker(with textField: UITextField){
        tempTextField = textField
        picker.datePickerMode = .time
        pickerMode = "time"
        picker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        textField.inputView = picker
        textField.inputAccessoryView = setUpToolBar()
    }
    
    @objc func dateChange(datePicker: UIDatePicker){
        tempTextField.text = formatDate(date: datePicker.date, mode: pickerMode)
    }
    
    func formatDate(date: Date, mode: String) -> String{
        let formatter = DateFormatter()
        if mode == "date"{
            formatter.dateStyle = .medium
        }
        if mode == "time"{
            formatter.dateFormat = "HH:mm"
        }
        return formatter.string(from: date)
    }
}

//MARK: - ToolBar
extension EditActivityViewController{
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
        pickerMode = ""
        tempTextField = UITextField()
    }
    
    @objc func doneBtnPressed(){
        
        if let datePicker = tempTextField.inputView as? UIDatePicker{
            tempTextField.text = formatDate(date: datePicker.date, mode: pickerMode)
            pickerMode = ""
            tempTextField = UITextField()
        }
        view.endEditing(true)
    }
}
