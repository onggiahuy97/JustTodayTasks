//
//  MonthlyView.swift
//  JustTodayTasks
//
//  Created by Huy Ong on 8/24/20.
//

import SwiftUI

struct MonthlyView: View {
    var body: some View {
        NavigationView {
            container.init()
                .navigationTitle(Text("Monthly"))
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private struct container: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            return MonthlyViewController()
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}

class MonthlyViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, MonthlyTask>! = nil
    var collectionView: UICollectionView! = nil
    
    var monthlyTasks: [MonthlyTask] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        configureDataSource()
    }
    
    func configureCollectionView() {
        let tabBarheight = UITabBarController().getHeight()
        let viewBounds = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.frame.size.height - tabBarheight)
        collectionView = UICollectionView(frame: viewBounds, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        view.addSubview(collectionView)
        
    }
    
    func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(88))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TextCell, MonthlyTask> { (cell, indexPath, task) in
            cell.monthlyTask = task
            cell.delegate = self
            cell.layer.borderColor = UIColor.secondarySystemBackground.cgColor
            cell.layer.borderWidth = 1
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, MonthlyTask>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, task) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: task)
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, MonthlyTask>()
        snapshot.appendSections([.main])
        snapshot.appendItems(monthlyTasks)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension MonthlyViewController: UICollectionViewDelegate, TextCellDelegate {
    func didTapAt(index: Int) {
        collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .top, animated: true)
        if index > 25 {
            UIView.animate(withDuration: 0.5) {
                self.collectionView.transform = CGAffineTransform(translationX: 0, y: -300)
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        collectionView.endEditing(true)
        collectionView.transform = .identity
    }
    
    func loadData() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("MonthlyTasks.json") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                print("FILE AVAILABLE")
                loadDataFromFile()
            } else {
                print("FILE NOT AVAILABLE")
                createFile()
            }
        } else {
            print("FILE PATH NOT AVAILABLE")
        }
    }
    
    func loadDataFromFile() {
        do {
            let decoder = JSONDecoder()
            let data = try Data(contentsOf: MonthlyViewController.tasksURL())
            monthlyTasks = try decoder.decode([MonthlyTask].self, from: data)
        } catch let error {
            print(error)
        }
    }
    
    func createFile() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        Array(1...38).forEach { monthlyTasks.append(.init(id: $0, text: "")) }
        do {
            let data = try encoder.encode(monthlyTasks)
            try data.write(to: MonthlyViewController.tasksURL(), options: .atomicWrite)
        } catch let error {
            print(error)
        }
    }
    
    static func tasksURL() -> URL {
        return URL(fileURLWithPath: "MonthlyTasks", relativeTo: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first).appendingPathExtension("json")
    }
}


struct MonthlyView_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyView()
    }
}
