//

//

//

import SwiftUI

// Protocol to notify when a report is added
protocol AddMedicalReportHostingControllerDelegate: AnyObject {
    func didAddMedicalReport()
}

class AddMedicalReportHostingController: UIHostingController<AddMedicalReportView> {
    weak var delegate: AddMedicalReportHostingControllerDelegate?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: AddMedicalReportView(onAdd: nil))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the onAdd callback to notify delegate
        rootView = AddMedicalReportView(onAdd: { [weak self] in
            DispatchQueue.main.async {
                self?.delegate?.didAddMedicalReport()
            }
        })
    }
}
