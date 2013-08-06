module Vex
  module Dsl
    module Wrappers
      module Parameters
        # Enables the underlying array to be treated as an array of key/value hashes
        def parameters=(val)
          if val.is_a? Array
            new_hash = Hash.new
            val.each do |value|
              unless value["key"].nil? or value["value"].nil? or value["key"].length < 2 or value["value"].length < 2
                new_hash[value["key"]] = value["value"]
              end
            end
            self.data = new_hash
          elsif val.is_a? Hash
            self.data = val
          else
            raise(ArgumentError, "Value must be a hash or array")
          end
        end
        
        class Wrapper
          def initialize(key,value)
            @key = key            
            @value = value
          end
          def key
            @key
          end
          def value
            @value
          end
        end
      end
    end
  end
end