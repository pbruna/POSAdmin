module Validations

	def validates_ip_format_of(*attr_names)
		attr_names.each do |attr_name|
			value = send(attr_name).class == Array ? send(attr_name).first : send(attr_name)
			begin
				IPAddress.parse value
			rescue ArgumentError => e
				self.errors.add(attr_name, e)
				next
			end
		end
	end
	
end