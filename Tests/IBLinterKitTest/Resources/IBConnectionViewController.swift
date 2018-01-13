import UIKit

class IBConnectionViewController: UIViewController, UITableViewDelegate {

    //@IBOutlet weak var label: UILabel!
    @IBOutlet var buttons: [UIButton]!

    @IBAction func touchUpInsideAction(_ sender: Any) {}
}

class InnerView: UIView {

    @IBOutlet weak var hogeLabel: UILabel!
}
