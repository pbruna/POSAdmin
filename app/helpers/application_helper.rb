module ApplicationHelper

  def content_header(title, header_size = "h1")
    content_tag(:div, content_tag(header_size.to_sym, title), :class => "content-header")
  end

  def value_for_field(object, attribute)
    object.respond_to?(attribute.to_sym) ? object.send(attribute) : nil
  end

  def options_for_form_tag(action)
    method = :post
    if action == "update"
      method = :put
    end
    [{:action => action}, {:method => method}]
  end

  def errors_to_list(*array)
    unless array.empty?
      list = "<ul>"
      array.each do |object|
        object.each do |k,v|
          list << "<li>#{k}: #{v.first}</li>"
        end
      end
      list << "</ul>"
      list.html_safe
    else
      return
    end
  end

end
