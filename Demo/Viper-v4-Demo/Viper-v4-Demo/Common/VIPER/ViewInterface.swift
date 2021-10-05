import SVProgressHUD

protocol ViewInterface: AnyObject {
    func showProgressHUD()
    func hideProgressHUD()
}

extension ViewInterface {

    func showProgressHUD() {
        SVProgressHUD.show()
    }

    func hideProgressHUD() {
        SVProgressHUD.dismiss()
    }
}
