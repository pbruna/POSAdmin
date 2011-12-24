module ScBranchServersHelper
  
  def column_input_div(title, attribute, *options)
    options = options.first
    options ||= {}
    method = attribute.split(/scLocation/)[1][1..-2]
    value = @scLocation.respond_to?(method) ? @scLocation.send(method) : nil
    "<div class='span5'>
			<p>
				<strong>#{title}</strong><br/>
				#{text_field_tag attribute.to_sym, value, options.merge(:required => true)}
			</p>
		</div>".html_safe
  end
  
end
