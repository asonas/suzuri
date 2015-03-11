module Suzuri
  class Choice < Entity
    install_class_operations :get

    def self.path
      "/choices"
    end
  end
end
