import UIKit

final class MainViewController: UIViewController {
    
    private lazy var mainView = MainView()
    private let viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.greetingButton.addTarget(self, action: #selector(showGreeting), for: .touchUpInside)
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        viewModel.onProductsUpdated = { [weak self] in
            self?.mainView.tableView.reloadData()
        }
        
        viewModel.getProducts()
    }
    
    @objc private func showGreeting() {
        let name = UserDefaults.standard.string(forKey: "userName") ?? "Гость"
        let modal = GreetingModalView(name: name)
        modal.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(modal)

        NSLayoutConstraint.activate([
            modal.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            modal.heightAnchor.constraint(equalToConstant: 200),
            modal.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            modal.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
        ])
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.reuseIdentifier, for: indexPath) as? ProductCell else {
            return UITableViewCell()
        }
        
        let product = viewModel.products[indexPath.row]
        cell.configure(product: product)
        
        return cell
    }
    
}
