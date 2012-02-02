module Validations

	def validates_ip_format_of(*attr_names)
		attr_names.each do |attr_name|
			begin
				IPAddress.parse send(attr_name)
			rescue ArgumentError => e
				self.errors.add(attr_name, e)
				next
			end
		end
	end
	
end