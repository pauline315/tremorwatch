import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    private let tableView = UITableView()
    private let earthquakeViewModel = EarthquakeViewModel()
    private let disposeBag = DisposeBag()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
   
    private func setupUI() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
   
    private func bindViewModel() {
        earthquakeViewModel.earthquakes
            .bind(to: tableView.rx.items(cellIdentifier: "cell")) { (index, earthquake: Earthquake, cell) in
                cell.textLabel?.text = "Magnitude: \(earthquake.magnitude) at \(earthquake.location)"
            }
            .disposed(by: disposeBag)
       
        earthquakeViewModel.errorMessage
            .subscribe(onNext: { [weak self] errorMessage in
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                }
            })
            .disposed(by: disposeBag)

    }
}
