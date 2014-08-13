require "thor"
require "terraform_inventory/terraform_state"

module TerraformInventory
  class Cli < Thor
    include Thor::Actions

    source_root(File.join(File.dirname(File.dirname(__dir__)), "templates"))

    desc "create", "Creates an Ansible inventory file from a Terraform state file"
    option :map, {
      required: true,
      type: :hash,
      banner: "resource_selector:host_group",
      desc: "Maps between Terraform resource selector and Ansible host group."
    }
    option :state, {
      banner: "<path to state file>",
      desc: "Path to a Terraform state file.",
      default: File.join(Dir.pwd, "terraform.tfstate")
    }
    def create(inventory_path)
      state = TerraformState.new `terraform show -no-color #{options[:state]}`

      @groups = state.group_by_host(options[:map])
      @ungrouped_resources = @groups[:none] || []
      @groups.delete(:none)

      template(
        "inventory.erb",
        inventory_path
      )
    end

    default_task :create
  end
end
