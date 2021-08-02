import UIKit

class ReportModal: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private var argument: Message!
    private var reportTitle: UILabel! = UILabel()
    private var reportReasonLabel: UILabel! = UILabel()
    private var reportReasonPicker: UITextField! = UITextField()
    private var reportMoreLabel: UILabel! = UILabel()
    private var reportMoreInput: UITextView! = UITextView()
    private var reportSubmitButton: PrimaryButton! = PrimaryButton(textKey: "Signaler")
    private let reasons = ["spam", "harassment", "hate-speech", "plagiarism", "fake-news"]
    private let reasonsTitles = ["Spam", "Harcèlement", "Discours haineux", "Plagiat", "Fausses informations"]
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        initLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initLayout()
    }
    
    func initLayout() {
        let reportReasonPickerContainer = UIView()
        self.addSubview(reportTitle)
        self.addSubview(reportReasonLabel)
        self.addSubview(reportReasonPickerContainer)
        self.addSubview(reportMoreLabel)
        self.addSubview(reportMoreInput)
        self.addSubview(reportSubmitButton)
        
        self.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        
        self.reportTitle.text = "Signaler un argument"
        self.reportTitle.setToSubtitle()
        self.reportTitle.setToBold()
        self.reportTitle.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.left.equalTo(self)
        }
        
        self.reportReasonLabel.text = "Signaler un argument"
        self.reportReasonLabel.setToSecondaryTextColor()
        self.reportReasonLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.reportTitle.snp.bottom).offset(25)
            make.left.equalTo(self)
        }
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        reportReasonPicker.inputView = pickerView
        
        reportReasonPickerContainer.addBorder(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor"), width: 0.2)
        reportReasonPickerContainer.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.reportReasonLabel.snp.bottom).offset(15)
            make.left.right.equalTo(self)
            make.height.equalTo(40)
        }
        
        reportReasonPickerContainer.addSubview(self.reportReasonPicker)
        self.reportReasonPicker.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(reportReasonPickerContainer).offset(5)
            make.bottom.equalTo(reportReasonPickerContainer).offset(-5)
            make.left.equalTo(reportReasonPickerContainer).offset(5)
            make.right.equalTo(reportReasonPickerContainer).offset(-5)
        }

        self.reportMoreLabel.text = "Dites nous en plus"
        self.reportMoreLabel.setToSecondaryTextColor()
        self.reportMoreLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.reportReasonPicker.snp.bottom).offset(15)
            make.left.equalTo(self)
        }
        
        self.reportMoreInput.addBorder(hexString: SettingsProvider.sharedInstance.getTheme(key: "borderBoxColor"), width: 0.2)
        self.reportMoreInput.font = UIFont.systemFont(ofSize: 17.0)
        self.reportMoreInput.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.reportMoreLabel.snp.bottom).offset(15)
            make.left.right.equalTo(self)
            make.height.equalTo(80)
        }
        
        self.reportSubmitButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.reportMoreInput.snp.bottom).offset(25)
            make.left.equalTo(self)
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return reasons.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return reasonsTitles[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        reportReasonPicker.text = reasonsTitles[row]
        print("REASON : \(reasons[row])")
    }
}
