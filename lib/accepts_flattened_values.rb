require 'active_support'

module AcceptsFlattenedValues
  extend ActiveSupport::Autoload

  autoload :Mixin
end

ActiveSupport.on_load(:active_record) do
  ActiveRecord::Base.send(:include, AcceptsFlattenedValues::Mixin)
end
