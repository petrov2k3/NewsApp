//
//  HomeViewController.swift
//  NewsApp
//
//  Created by Ivan Petrov on 21.05.2025.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var tableView = UITableView()
    private let cellIdentifier = "NewsCell"
    
    private var newsArray = ["Title 1", "Title 2", "Title 3", "Title 4", "Title 5", "Title 6", "Title 7", "Title 8", "Title 9"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.yellow
        //view.backgroundColor = .systemBackground
        navigationItem.title = "Головна"
        
        //title = "Головна"
        
        //setupUI()
        
        createTable()
    }
    
    func createTable() {
        self.tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        // подписываемся на протоколы; делегируем и передаём информацию этому контроллеру (self)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(tableView)
    }
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let newsTitle = newsArray[indexPath.row]
        
        //cell.textLabel?.text = // deprecated
        
        var config = cell.defaultContentConfiguration()
        config.text = newsTitle
        config.secondaryText = "Description \(indexPath.row + 1)"
        cell.contentConfiguration = config
        
        /*
        cell.accessoryType = .detailButton
        
        switch indexPath.section {
        case 0:
            cell.backgroundColor = UIColor.red
        case 1:
            cell.backgroundColor = UIColor.blue
        case 2:
            cell.backgroundColor = UIColor.orange
        default:
            break
        }
         */
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    /*
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("Accessory path = ", indexPath)
        
        let ounerCell = tableView.cellForRow(at: indexPath)
        
        //print("Cell title = ", ounerCell?.textLabel?.text ?? "nil") // deprecated
        
        if let config = ounerCell?.contentConfiguration as? UIListContentConfiguration {
            print("Cell title = \(config.text ?? "nil")")
        } else {
            print("Не удалось получить текст из contentConfiguration")
        }
        
              
    }
     */
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath.row)
        
        let number = newsArray[indexPath.row]
        print(number)
        
        //print("Обрана новина: \(newsArray[indexPath.row])")
        //tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
}


//line for testing commits

//code 2
/*
 
    code 2
    code 2
    code 2
 
 */

//code 3New
/*
 
    code 3new
    code 3new
    code 3new
 
 */
