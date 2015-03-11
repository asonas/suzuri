module Suzuri
  class Item < Entity
    install_class_operations :get

    def self.path
      "/items"
    end
  end
end
