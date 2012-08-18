require "active_support/concern"
require "active_support/core_ext/class/attribute"
require "active_support/core_ext/hash/keys"

module AcceptsFlattenedValues
  require "accepts_flattened_values/version"

  extend ActiveSupport::Concern

  included do
    class_attribute :flattened_values_options, :instance_writer => false
    self.flattened_values_options = {}
  end

  module ClassMethods
    def accepts_flattened_values_for(*attr_names)
      options = { :separator => ",", :attribute => :value }
      options.update(attr_names.extract_options!)
      options.assert_valid_keys(:separator, :attribute)

      attr_names.each do |association_name|
        if reflection = reflect_on_association(association_name)
          reflection.options[:autosave] = true
          add_autosave_association_callbacks(reflection)

          options = options.merge(:klass => reflection.klass)
          self.flattened_values_options = flattened_values_options.merge(association_name.to_sym => options)

          unless reflection.collection?
            raise ArugmentError, "Assocation `#{association_name}' must be a has_many or has_and_belongs_to_many."
          end

          # def pirate_values
          #   retrieve_flattened_values_for_association(:pirate)
          # end
          # def pirate_values=(string)
          #   assign_flattened_values_for_association(:pirate, string)
          # end
          class_eval <<-RUBY, __FILE__, __LINE__ + 1
            if method_defined?(:#{association_name}_values)
              remove_method(:#{association_name}_values)
            end
            def #{association_name}_values
              retrieve_flattened_values_for_association(:#{association_name})
            end
            if method_defined?(:#{association_name}_values=)
              remove_method(:#{association_name}_values=)
            end
            def #{association_name}_values=(string)
              assign_flattened_values_for_association(:#{association_name}, string)
              string
            end
          RUBY
        else
          raise ArgumentError, "No association found for name `#{association_name}'. Has it been defined yet?"
        end
      end
    end
  end

  protected
    def retrieve_flattened_values_for_association(association)
      options = flattened_values_options[association]
      send(association).map(&options[:attribute]).join(options[:separator])
    end

    def assign_flattened_values_for_association(association, values)
      options = flattened_values_options[association]
      values = values.split(options[:separator])

      records = values.map do |value|
        options[:klass].where(options[:attribute] => value).first_or_initialize
      end
      send("#{association}=", records)
    end
end
