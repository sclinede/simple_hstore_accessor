require 'active_support'
require 'active_record'
require 'simple_hstore_accessor/version'

module SimpleHstoreAccessor
  def hstore_accessor(hstore_attribute, *keys)
    Array(keys).flatten.each do |key|
      define_method("#{key}=") do |value|
        send("#{hstore_attribute}_will_change!")
        send("#{hstore_attribute}=", (send(hstore_attribute) || {}).merge(key.to_s => value))
      end
      define_method(key) do
        send(hstore_attribute) && send(hstore_attribute)[key.to_s]
      end
    end
  end
end

ActiveSupport.on_load(:active_record) do
  ActiveRecord::Base.send(:extend, SimpleHstoreAccessor)
end
