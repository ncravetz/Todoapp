require "cuba"
require "cuba/render"
require "ohm"

Cuba.plugin(Cuba::Render)
Cuba.use Rack::Session::Cookie, secret: "foobar"
 
require_relative "models/task"

Ohm.redis = Redic.new("redis://127.0.0.1:6379") 

Cuba.define do
  @page = {}
 
  on get, "tasks/:id" do |id|
    res.write(view("task", task: Task[id]))
  end
  
  on post, "cargar" do
    task = Task.create(
      title: req.POST["title"],
      status: "to_do" 
    )
    res.redirect("/tasks/#{task.id}")
  end
  
  on post, "describir" do
    task = Task[req.POST["task_id"]]
  task.update(
      description: req.POST["description"]
    )
    res.redirect("/tasks/#{task.id}")
  end
  
  on post, "status_change_at_home" do
    task = Task[req.POST["task_id"]]
    if task.status == "done"
      task.update(
        status: "to_do"
      )
      else
        task.update(
          status: "done"
        )
    end  
      res.redirect("/")
  end
  
  on post, "status_change_at_task" do
    task = Task[req.POST["task_id"]]
    if task.status == "done"
      task.update(
        status: "to_do"
      )
      else
        task.update(
          status: "done"
        )
    end  
      res.redirect("/tasks/#{task.id}")
  end
  
  on root do
    res.write(view("home", tasks: Task.all))
  end
end