require 'active_support'

module AcceptsFlattenedValues
  autoload :Mixin, 'accepts_flattened_values/mixin'
end

ActiveSupport.on_load(:active_record) do
  ActiveRecord::Base.send(:include, AcceptsFlattenedValues::Mixin)
end
