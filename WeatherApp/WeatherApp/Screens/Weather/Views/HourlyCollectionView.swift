import UIKit

final class HourlyCollectionView: UIView {

    private var items: [HourlyItem] = []
    private let collectionView: UICollectionView
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 60, height: 100)
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .Weather.cardBackground
        layer.cornerRadius = 16
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.Weather.cardBorder.cgColor
        clipsToBounds = true

        titleLabel.text = "ПОЧАСОВОЙ ПРОГНОЗ"
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .Weather.secondaryText
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

        let separator = UIView()
        separator.backgroundColor = .Weather.separator
        separator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separator)

        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.register(HourlyCell.self, forCellWithReuseIdentifier: HourlyCell.reuseID)
        addSubview(collectionView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),

            separator.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            separator.heightAnchor.constraint(equalToConstant: 0.5),

            collectionView.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 4),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            collectionView.heightAnchor.constraint(equalToConstant: 110)
        ])
    }

    func configure(with items: [HourlyItem]) {
        self.items = items
        collectionView.reloadData()
    }
}

extension HourlyCollectionView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCell.reuseID, for: indexPath) as! HourlyCell
        cell.configure(with: items[indexPath.item])
        return cell
    }
}
