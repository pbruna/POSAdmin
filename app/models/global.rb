include PosAdmin::Connection

module  Global
  module Instance

    def delete_childrens!
      childs = all_childrens
      childs.each do |child|
        begin
          child.destroy
        rescue Exception => e
          puts e.message
          puts e.backtrace.inspect
          return false
        end
        true
      end
    end

    def all_childrens
      childs = scope(:sub).all
      childs.sort! do |a,b|
        a.dn.split(/,/).size <=> b.dn.split(/,/).size
      end
      childs.shift # remove self from the Array
      childs.reverse # The last goes first
    end

    def description_text
      if defined?(description)
        description.join("\n")
      else
        nil
      end
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
      if attributes[main_attribute.to_sym]
        rdn = "#{main_attribute}=#{attributes[main_attribute.to_sym]},#{base}"
        attributes.delete(main_attribute.to_sym) # We remove the main attribute to avoid a LDAP Error
        update(attributes)
        move(rdn)
      else
        update(attributes)
      end
      self
    end

  end

  module Class

    def all
      array = []
      Treequel::Model.directory.filter(:objectClass => self.model_objectclasses).each do |ou|
        array << ou
      end
      array
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
