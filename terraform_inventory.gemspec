# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "terraform_inventory/version"

Gem::Specification.new do |spec|
  spec.name          = "terraform_inventory"
  spec.version       = TerraformInventory::VERSION
  spec.authors       = ["Tyler Cross"]
  spec.email         = ["tcross@bandwidth.com"]
  spec.description   = %q(Map Terraform state to an Ansible inventory file)
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/bandwidthcom/terraform-inventory"
  spec.licenses      = %w[MIT]

  spec.executables   = %w[tinventory]

  spec.files         = %w[LICENSE.md README.md Thorfile terraform_inventory.gemspec]
  spec.files        += Dir.glob("bin/**/*")
  spec.files        += Dir.glob("lib/**/*.rb")
  spec.files        += Dir.glob("spec/**/*")
  spec.files        += Dir.glob("templates/**/*")

  spec.test_files    = Dir.glob("spec/**/*")

  spec.require_paths = %w[lib]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "thor"
end
