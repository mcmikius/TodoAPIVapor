

import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
  // register todo controller routes
  let todoController = TodoController()

  router.get("todos", use: todoController.index)
  router.post("todos", use: todoController.create)
  router.delete("todos", Todo.parameter, use: todoController.delete)
}
