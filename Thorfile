$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

require "bundler"
require "thor/rake_compat"

class Default < Thor
  include Thor::RakeCompat
  Bundler::GemHelper.install_tasks

  desc "build", "Build terraform_inventory-#{TerraformInventory::VERSION}.gem into the pkg directory"
  def build
    Rake::Task["build"].execute
  end

  desc "install", "Build and install terraform_inventory-#{TerraformInventory::VERSION}.gem into system gems"
  def install
    Rake::Task["install"].execute
  end

  desc "release", "Create tag v#{TerraformInventory::VERSION} and build and push terraform_inventory-#{TerraformInventory::VERSION}.gem to Rubygems"
  def release
    Rake::Task["release"].execute
  end

  desc "rubocop", "Run Rubocop on all Ruby files"
  def rubocop
    exec "rubocop"
  end

  desc "spec", "Run tests."
  def spec
    exec "rspec spec"
  end

  desc "check", "Lint, style, and test."
  def check
    invoke :rubocop
    invoke :spec
  end
end
