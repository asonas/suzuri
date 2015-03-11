module Suzuri
  class User < Entity
    install_class_operations :get

    def self.path
      "/users"
    end
  end
end
