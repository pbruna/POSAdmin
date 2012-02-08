require 'POSAdmin/connection'

module  Global
  module Instance

    def delete_childrens!
      if has_childrens?
        childs = all_childrens
        childs.each do |child|
          begin
            child.destroy
          rescue Exception => e
            puts e.message
            return false
          end
        end      
      end
      true
    end

    def all_childrens
      childs = scope(:sub).all
      childs.sort! do |a,b|
        a.dn.split(/,/).size <=> b.dn.split(/,/).size
      end
      childs.shift # remove self from the Array
      childs.reverse # The last goes first
    end

    def has_childrens?
      scope(:sub).all.size > 0 ? true : false
    end

    def description_text
      respond_to?(:description) ? description.join("\n") : nil
    end

    def short_name
      if defined?(main_attribute)
        send("#{main_attribute}").first
      else
        nil
      end
    end

    def short_name=(name)
      send("#{main_attribute}=",name)
    end

    def base
      dn.split(/,/)[1..-1].join(",")
    end

    def ou_dn
      dn.split(/,/)[-3, 3].join(",")
    end

    def ou_name
      ou_dn.split(/,/)[0].split(/\=/)[1]
    end

    def update!(attributes)
      rdn = ""
      if attributes[main_attribute.to_sym] != self.send(self.send("main_attribute"))
        rdn = "#{main_attribute}=#{attributes[main_attribute.to_sym]},#{base}"
        attributes.delete(main_attribute.to_sym)
      end
      # extensions.first devuelve el modelo
      entry = extensions.first.create(self.dn, attributes)
      if entry.save
        entry.move(rdn) unless rdn.blank?
        entry
      else
        entry
      end
    end

  end

  module Class

    def all
      #array = []
      Treequel::Model.directory.filter(:objectClass => self.model_objectclasses) #.each do |ou|
      #   array << ou
      # end
      # array
    end

    def find(id)
      attrs, base = id.split(/,/,2)
      name = attrs.split(/\=/)
      query = {name[0].to_sym => name[1]}
      filter(query).from(base).first
    end

    def main_attribute(attribute = nil)
      if attribute
        define_method(:main_attribute) {return attribute}
      else
        raise RequiredValueNotDeclared, "You must declare a value for main_attribute in your model"
      end
    end
  end

end
