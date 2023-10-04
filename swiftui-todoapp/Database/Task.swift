//
//  Task.swift
//  swiftui-todoapp
//
//  Created by Bryan on 04/10/23.
//

import Foundation
import SQLite

struct Task {
    var id: Int?
    var task: String
}

// SQLite Database
class Database {
    private let tasks = Table("tasks")
    private let id = Expression<Int>("id")
    private let task = Expression<String>("task")
    
    private var db: Connection?
    
    init() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
            ).first!
            db = try Connection("\(path)/tasks.sqlite3")
            createTable()
        } catch {
            print("Error initializing database: \(error)")
        }
    }
    
    private func createTable() {
        do {
            try db?.run(tasks.create(ifNotExists: true) { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(task)
            })
        } catch {
            print("Error creating table: \(error)")
        }
    }
    
    func addTask(taskName: String) {
        let insertTask = tasks.insert(task <- taskName)
        do {
            try db?.run(insertTask)
        } catch {
            print("Error inserting task: \(error)")
        }
    }
    
    func deleteTask(id: Int) {
        let taskToDelete = tasks.filter(self.id == id)
        do {
            try db?.run(taskToDelete.delete())
        } catch {
            print("Error deleting task: \(error)")
        }
    }
    
    func getAllTasks() -> [Task] {
        var tasksArray: [Task] = []
        do {
            for task in try db!.prepare(tasks) {
                let t = Task(id: task[id], task: task[self.task])
                tasksArray.append(t)
            }
        } catch {
            print("Error fetching tasks: \(error)")
        }
        return tasksArray
    }
}
