

import FluentSQLite
import Vapor

final class TodoController {
  /// Returns a list of all Todo items.
  func index(_ req: Request) -> Future<[Todo]> {
    return Todo.query(on: req).all()
  }

  /// Creates a new Todo item.
  func create(_ req: Request) -> Future<Todo> {
    return req.content.get(String.self, at: "title").flatMap { title in
      let todo = Todo(title: title)
      return todo.save(on: req)
    }
  }

  /// Deletes an existing Todo item.
  func delete(_ req: Request) throws -> Future<HTTPStatus> {
    return try req.parameters.next(Todo.self).flatMap { todo in
      return todo.delete(on: req)
    }.transform(to: .ok)
  }
}
