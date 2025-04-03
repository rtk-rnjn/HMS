//

//

//

import UIKit

class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: Internal

    @IBOutlet var pickerView: UIPickerView!

    var options: [String: String] = ["": ""]
    var completionHandler: ((String, String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self

        let sortedOptions = options.sorted {
            if let firstNumber = Int($0.key), let secondNumber = Int($1.key) {
                return firstNumber < secondNumber
            }

            return $0.value < $1.value
        }
        let selectedOption = sortedOptions[0]
        self.selectedOption = selectedOption
        pickerView.selectRow(0, inComponent: 0, animated: false)
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let sortedOptions = options.sorted {
            if let firstNumber = Int($0.key), let secondNumber = Int($1.key) {
                return firstNumber < secondNumber
            }
            return $0.value < $1.value
        }
        return sortedOptions[row].value
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let sortedOptions = options.sorted {
            if let firstNumber = Int($0.key), let secondNumber = Int($1.key) {
                return firstNumber < secondNumber
            }
            return $0.value < $1.value
        }
        let selectedOption = sortedOptions[row]
        self.selectedOption = selectedOption
    }

    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true) {
            guard let selectedOption = self.selectedOption else { return }
            self.completionHandler?(selectedOption.key, selectedOption.value)
        }
    }

    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: Private

    private var selectedOption: (key: String, value: String)?

}
