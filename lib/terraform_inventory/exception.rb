module TerraformInventory
  module Exception
    class ResourceNotFoundException < StandardError
      def initialize(resource_selector)
        super("Resource not found using selector: '#{resource_selector}'")
      end
    end

    class InvalidResourceSelectorException < StandardError
      def initialize(resource_selector)
        super("Invalid resource selector: '#{resource_selector}'")
      end
    end
  end
end
