module ApplicationHelper
  
  def content_header(title)
    content_tag(:div, content_tag(:h1, title), :class => "content-header")
  end
  
  def value_for_field(object, attribute)
    object.respond_to?(attribute.to_sym) ? object.send(attribute) : nil
  end
end
