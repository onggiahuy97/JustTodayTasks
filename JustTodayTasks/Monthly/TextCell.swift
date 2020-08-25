//
//  TextCell.swift
//  JustTodayTasks
//
//  Created by Huy Ong on 8/24/20.
//

import UIKit

protocol TextCellDelegate {
    func didTapAt(index: Int)
}

class TextCell: UICollectionViewCell {
    static let reuseIdentifier = "cellId"
    
    var monthlyTask: MonthlyTask? {
        didSet {
            guard let task = monthlyTask else { return }
            label.text = "\(task.id > 31 ? "..." : "\(task.id)")"
            text.text = task.text
        }
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let text: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 16)
        return tv
    }()
    
    var delegate: TextCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubview(label)
        contentView.addSubview(text)
        text.delegate = self
        
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            text.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: inset),
            text.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            text.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            text.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
        ])
    }
}

extension TextCell: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let decoder = JSONDecoder()
        
        guard let monthlyTask = monthlyTask else { return }
        
        do {
            let decodedData = try Data(contentsOf: MonthlyViewController.tasksURL())
            var tasks = try decoder.decode([MonthlyTask].self, from: decodedData)
            tasks[monthlyTask.id - 1].text = textView.text
            let encodedData = try encoder.encode(tasks)
            try encodedData.write(to: MonthlyViewController.tasksURL(), options: .atomicWrite)
        } catch let error {
            print(error)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("Did tap")
        delegate?.didTapAt(index: monthlyTask!.id - 1)
    }
}
