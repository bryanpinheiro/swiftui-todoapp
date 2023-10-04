//
//  TodoView.swift
//  swiftui-todoapp
//
//  Created by Bryan on 04/10/23.
//

import SwiftUI

struct TodoView: View {
    @State private var taskName: String = ""
    @State private var tasks: [Task] = []
    private var database = Database()
    
    var body: some View {
        VStack {
            TextField("Enter a task", text: $taskName)
                .padding()
            
            Button(action: {
                addTask()
            }) {
                Text("Add Task")
            }
            .padding()
            
            List {
                ForEach(tasks, id: \.id) { task in
                    HStack {
                        Text(task.task)
                        Spacer()
                        Button(action: {
                            deleteTask(id: task.id!)
                        }) {
                            Image(systemName: "trash")
                        }
                        .foregroundColor(.red)
                    }
                }
            }
        }
        .onAppear {
            fetchTasks()
        }
    }
    
    private func addTask() {
        database.addTask(taskName: taskName)
        taskName = ""
        fetchTasks()
    }
    
    private func fetchTasks() {
        tasks = database.getAllTasks()
    }
    
    private func deleteTask(id: Int) {
        database.deleteTask(id: id)
        fetchTasks()
    }
}

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        TodoView()
    }
}
