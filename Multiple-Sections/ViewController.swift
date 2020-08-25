//
//  ViewController.swift
//  Multiple-Sections
//
//  Created by Liubov Kaper  on 8/18/20.
//  Copyright © 2020 Luba Kaper. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //1
    enum Section: Int, CaseIterable {
        case grid
        case single
        case double
        // TODO: add 3rd section
        
        var columnCount: Int {
            switch self {
            case .grid:
                return 4 // 4 columns
            case .single:
                return 1 // 1 column
            case .double:
                return 2
            }
        }
    }
    
    //2
    @IBOutlet weak var collectionView: UICollectionView!// de
    
    typealias  DataSource = UICollectionViewDiffableDataSource<Section, Int>// both have to conform to hushable
    
    private var dataSource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
        // Do any additional setup after loading the view.
    }
    
    //4
    private func configureCollectionView() {
        //overriding flow layout to compositional layout
        
        //if done programmatically:
        //collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        
        // if Storyboard:
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = .systemBackground
        
        // register supplimentary headerView
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView")
    }
    
    // 3
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            // find out what section we working with
            guard let sectionType = Section(rawValue: sectionIndex) else {
                return nil
            }
            let columns = sectionType.columnCount // 1 or 4 columns
            // create the layout: item->group->section->layout
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            // TODO:add insets
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let groupHeight = columns == 1 ? NSCollectionLayoutDimension.absolute(200) : columns == 2 ? NSCollectionLayoutDimension.fractionalWidth(0.5) :  NSCollectionLayoutDimension.fractionalWidth(0.25)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            let section = NSCollectionLayoutSection(group: group)
            
            //configure the headser view
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [header]
            
            return section
        }
        
        return layout
    }
    //5
    private func configureDataSource() {
        //1
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            // configure the cell
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "labelCell", for: indexPath) as? LabelCell else {
                fatalError("could not dequeue LabelCell")
            }
            cell.textLabel.text = "\(item)"
            if indexPath.section == 0 {
                cell.backgroundColor = .systemOrange
                cell.layer.cornerRadius = 12
            } else if indexPath.section == 1{
                cell.backgroundColor = .systemGreen
                cell.layer.cornerRadius = 0
            } else {
                cell.backgroundColor = .systemYellow
                cell.layer.cornerRadius = 0
            }
            return cell
        })
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard let headerView = self.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath) as? HeaderView else {
                fatalError("could not dequeue HeaderView")
            }
            headerView.textLabel.text = "\(Section.allCases[indexPath.section])".capitalized
            return headerView
        }
        
        //2
        // setup initial snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.grid, .single, .double])
        snapshot.appendItems(Array(1...12), toSection: .grid)
        snapshot.appendItems(Array(13...20), toSection: .single)
        snapshot.appendItems(Array(21...35), toSection: .double)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

}

