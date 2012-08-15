module ApplicationHelper
  def javascript(*files)
    content_for(:head) {javascript_include_tag(*files)}
  end
  def link_to_remove_question(name, f)
    f.hidden_field(:_destroy) + link_to(name,"#",onclick: "remove_question(this)",class: "btn btn-danger")
  end
 
  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter if block_given?
    presenter
  end
end
