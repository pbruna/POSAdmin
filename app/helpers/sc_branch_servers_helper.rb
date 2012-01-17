module ScBranchServersHelper

  def column_input_div(title, attribute, *options)
    options = options.first
    options ||= {}
    method, params = attribute.split(/scLocation/)[1].split(/\]\[/).map {|l| l.gsub(/[\[\]]/,"")}
    if params.nil?
      value = @scLocation.respond_to?(method) ? @scLocation.send(method) : nil
    else
      value = @scLocation.respond_to?(method) ? @scLocation.send(method, params) : nil
    end

    "<div class='span5'>
			<p>
				<strong>#{title}</strong><br/>
				#{text_field_tag attribute.to_sym, value, options.merge(:required => true)}
			</p>
		</div>".html_safe
  end


end
