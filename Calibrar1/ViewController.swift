//
//  ViewController.swift
//  Calibrar1
//
//  Created by Jake Aranas on 1/16/22.
//

import UIKit
import Moya

class ViewController: UIViewController {

    @IBOutlet weak var tableViewUser: UITableView!

    var todos = [Todo]()
    let provider = MoyaProvider<TodoServices>()

    override func viewDidLoad() {
        super.viewDidLoad()
        provider.request(.readTodos) { result in
            switch result {
                case .success(let response):
                    do {
                        let todoList = try JSONDecoder().decode([Todo].self, from: response.data)
                        self.todos = todoList
                        self.tableViewUser.reloadData()
                    } catch (let error)  {
                        print(error)
                    }
                case .failure(let error):
                    print(error)
            }
        }
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))

    }
    
//    @objc private func didTapAdd() {
//            let alert = UIAlertController(title: "New Todo List", message: "Enter New Item", preferredStyle: .alert)
//            alert.addTextField(configurationHandler: nil)
//            alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak self] _ in
//                guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
//                    return
//                }
//
////                self?.createItem(name: text)
//            }))
//
//            present(alert, animated: true)
//        }

    @IBAction func pressedAddUser(_ sender: Any) {
        let newTodo = Todo(id: 60, title: "This is a new todo")
//        let alert = UIAlertController(title: "New Todo List", message: "Enter New Item", preferredStyle: .alert)
//        alert.addTextField(configurationHandler: nil)
//        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak self] _ in
//            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
//                return
//            }
//                self?.createItem(name: text)
//        }))
//
//        present(alert, animated: true)
        
        provider.request(.createTodo(title: newTodo.title)) { result in
            switch result {
                case .success(let response):
                    do {
                        _ = try JSONDecoder().decode(Todo.self, from: response.data)
                        self.todos.insert(newTodo, at: 0)
                        self.tableViewUser.reloadData()
                    } catch let error {
                        print(error)
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let todos = todos[indexPath.row]
        cell.textLabel?.text = todos.title
        return cell
    }


    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            let todo = todos[indexPath.row]
            provider.request(.deleteTodo(id: todo.id)) { result in
                switch result {
                    case.success(let response):
                        print("Delete: \(response)")
                        self.todos.remove(at: indexPath.row)
                        self.tableViewUser.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }

}



