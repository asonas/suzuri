module Suzuri
  class Favorite < Entity
    install_class_operations :get

    def self.path
      "/favorites"
    end
  end
end
