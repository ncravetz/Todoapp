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
      status: "todo" 
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
  
  on root do
    res.write(view("home", tasks: Task.all))
  end
end