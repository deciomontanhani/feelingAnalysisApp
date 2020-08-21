import UIKit

final class TweetsListView: UIView {

    weak var delegate: TweetsListViewDelegate?

    private lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.delegate = self
        view.placeholder = "Digite um usuário do Twitter aqui"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var loadingErrorView: LoadingErrorView = {
        let view = LoadingErrorView()
        view.delegate = self
        return view
    }()

    private lazy var tableView: UITableView = {
            let tableView = UITableView()
    //        tableView.register(ShelfCardItemTableViewCell.self, forCellReuseIdentifier: ShelfCardItemTableViewCell.className)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.isScrollEnabled = false
            tableView.showsVerticalScrollIndicator = false
            tableView.translatesAutoresizingMaskIntoConstraints = false
            return tableView
        }()

    init() {
        super.init(frame: .zero)
        buildViewCode()
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

}

extension TweetsListView: ViewCode {
    func buildHierarchy() {
        addSubview(searchBar)
        addSubview(loadingErrorView)
        addSubview(tableView)
    }

    func buildConstraints() {
        searchBar.top(to: self, self.safeAreaLayoutGuide.topAnchor)
        searchBar.left(to: self)
        searchBar.right(to: self)

        loadingErrorView.topToBottom(of: searchBar)
        loadingErrorView.left(to: self)
        loadingErrorView.right(to: self)
        loadingErrorView.bottom(to: self)

        tableView.topToBottom(of: searchBar)
        tableView.left(to: self)
        tableView.right(to: self)
        tableView.bottom(to: self)

    }

    func additionalSetup() {
        loadingErrorView.set(state: .error)
        backgroundColor = .white
    }
}

extension TweetsListView: TweetsListViewProtocol {}

extension TweetsListView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        delegate?.searchProfile(searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
}

extension TweetsListView: LoadingErrorViewProtocol {
    func retry() {
        // delegate?.retry()
    }
}

extension TweetsListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

extension TweetsListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
