require 'active_support/concern'

module AcceptsFlattenedValues::Mixin
  extend ActiveSupport::Concern

  included do
    class_inheritable_accessor :flattened_values_options, :flattened_values_klasses
    self.flattened_values_options = {}
    self.flattened_values_klasses = {}
  end

  module ClassMethods
    def accepts_flattened_values_for(*attr_names)
      options = { :separator => ',', :value => :value }
      options.update(attr_names.extract_options!)
      options.assert_valid_keys(:separator, :value)

      attr_names.each do |association_name|
        if reflection = reflect_on_association(association_name)
          reflection.options[:autosave] = true
          add_autosave_association_callbacks(reflection)
          flattened_values_options[association_name.to_sym] = options
          flattened_values_klasses[association_name.to_sym] = reflection.klass

          unless reflection.collection?
            raise ArugmentError, "Assocation `#{association_name}' must be a collection."
          end

          # def pirate_values
          #   get_flattened_values_for_association(:pirate)
          # end
          #
          # def pirate_values=(values)
          #   assign_flattened_values_for_association(:pirate, values)
          # end
          class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
            if method_defined?(:#{association_name}_values)
              remove_method(:#{association_name}_values)
            end
            def #{association_name}_values
              get_flattened_values_for_association(:#{association_name})
            end

            if method_defined?(:#{association_name}_values=)
              remove_method(:#{association_name}_values=)
            end
            def #{association_name}_values=(values)
              assign_flattened_values_for_association(:#{association_name}, values)
            end
          RUBY_EVAL
        else
          raise ArgumentError, "No association found for name `#{association_name}'. Has it been defined yet?"
        end
      end
    end
  end

  private
    def get_flattened_values_for_association(association_name)
      options     = flattened_values_options[association_name]
      association = send(association_name)

      association.collect(&options[:value]).join(options[:separator])
    end

    def assign_flattened_values_for_association(association_name, values)
      options = flattened_values_options[association_name]
      klass   = flattened_values_klasses[association_name]
      values  = values.split(options[:separator])

      new_ids = []
      values.each do |value|
        object = klass.send(:"find_or_create_by_#{options[:value]}", value)
        new_ids << object.id
      end

      send(:"#{association_name.to_s.singularize}_ids=", new_ids)
    end
end
