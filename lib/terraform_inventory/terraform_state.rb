require "yaml"
require "terraform_inventory/exception"

module TerraformInventory
  class TerraformState
    # Find a resource given a resource selector.
    #
    # A resource selector is composed of the following:
    #   resource_type (ex. aws_instance)
    #   resource_name (ex. web)
    #   resource_number (ex. 1)
    #
    # Here are a few examples of resource selectors:
    #   aws_instance.web.1  -  selects a specific aws_instance resource named web
    #   aws_instance.web    -  selects all aws_instance resources named web
    #
    def find_resource(resource_selector)
      resource_type, resource_name, resource_number = parse_resource_selector(resource_selector)

      if resource_number
        [@state[resource_type][resource_name][resource_number]]
      else
        @state[resource_type][resource_name]
      end
    end

    def group_by_host(resource_host_group_mapping)
      resource_host_group_mapping.reduce({}) do |data, (resource_selector, host_group)| # rubocop:disable Style/EachWithObject
        data[host_group.to_sym] ||= []
        data[host_group.to_sym].concat find_resource(resource_selector)

        data
      end
    end

    def initialize(stateText)
      @state = split_state(
        YAML.load(
          stateText
            .gsub(/\e\[(\d+)m/, "") # Hack to get rid of ASCII color codes in Terraform output
            .gsub(/\s=\s/, ": ")    # Use colons so we can parse as YAML
            .gsub(/: \n/, ": ''\n") # Need to have quotes in order to parse as YAML
            .split(/\n\n/)          # Grab only text that is related to resource state (exclude outputs)
            .first                  # We only want the first match
        )
      )
    end

  private

    def parse_resource_selector(resource_selector)
      resource_selector_regex = /^(\w+)\.(\w+)(?:\.(\d+))?$/
      matches = resource_selector_regex.match(resource_selector)

      raise Exception::InvalidResourceSelectorException, resource_selector if matches.nil?

      resource_type = matches[1]
      resource_name = matches[2]
      resource_number = if matches[3].nil?
        nil
      else
        matches[3].to_i
      end

      [resource_type, resource_name, resource_number]
    end

    def split_state(state)
      state.reduce({}) do |data, (resource_selector, resource_attributes)| # rubocop:disable Style/EachWithObject
        resource_type, resource_name, _resource_number = parse_resource_selector(resource_selector)

        data[resource_type] ||= {}
        data[resource_type][resource_name] ||= []
        data[resource_type][resource_name] << resource_attributes

        data
      end
    end
  end
end
