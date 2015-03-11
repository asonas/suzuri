module Suzuri
  module Operations
    ACCEPT_PARAMS_ID = %i(choices_id user_id)

    attr_accessor :assign_path

    def install_class_operations(*operations)
      define_create if operations.include?(:create)
      define_get if operations.include?(:get)
    end

    def define_get
      instance_eval do
        def get(params = {})
          @assign_path = parse_if_hash_key_exists(path, params, :room_id)
          attach_nested_resource_id(params)
          convert(Suzuri.client.get(@assign_path, params))
        end
      end
    end

    def define_create
      instance_eval do
        def create(params = {})
          @assign_path = parse_if_hash_key_exists(path, params, :room_id)
          attach_nested_resource_id(params)
          convert(Suzuri.client.post(@assign_path, params))
        end
      end
    end

    private
    def parse_if_hash_key_exists(string, hash, key)
      if hash.include?(key)
        string % hash.delete(key)
      else
        string
      end
    end

    def attach_nested_resource_id(params)
      ACCEPT_PARAMS_ID.each do |id_name|
        next unless params.include? id_name
        @assign_path += "/#{params.delete(id_name)}"
      end
    end
  end
end
