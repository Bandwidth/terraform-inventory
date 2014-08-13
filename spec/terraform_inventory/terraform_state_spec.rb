require "spec_helper"

# rubocop:disable Style/TrailingWhitespace
terraform_show_output = %(
aws_instance.web.0:
  id = i-1299293e
  ami = ami-e84d8480
  availability_zone = us-east-1a
  instance_type = m3.medium
  key_name = some-key
  private_dns = ip-10-63-149-246.ec2.internal
  private_ip = 10.63.149.246
  public_dns = ec2-54-167-40-22.compute-1.amazonaws.com
  public_ip = 54.167.40.22
  security_groups.# = 1
  security_groups.0 = ansible-managed
  subnet_id = 
aws_instance.web.1:
  id = i-b69b2b9a
  ami = ami-e84d8480
  availability_zone = us-east-1a
  instance_type = m3.medium
  key_name = some-key
  private_dns = ip-10-179-191-171.ec2.internal
  private_ip = 10.179.191.171
  public_dns = ec2-54-83-95-180.compute-1.amazonaws.com
  public_ip = 54.83.95.180
  security_groups.# = 1
  security_groups.0 = ansible-managed
  subnet_id = 
heroku_app.default:
  id = some-heroku-app
  config_vars.# = 1
  config_vars.0.PORT = 80
  git_url = git@heroku.com:some-heroku-app.git
  heroku_hostname = some-heroku-app.herokuapp.com
  name = some-heroku-app
  region = us
  stack = cedar
  web_url = http://some-heroku-app.herokuapp.com/

Outputs:

some-output = ADDRESS<54.167.40.22,54.83.95.180> USER<ubuntu>
)

describe TerraformInventory::TerraformState do
  let(:state) { TerraformInventory::TerraformState.new terraform_show_output }

  describe "#find_resource" do
    context "using a resource_selector without resource_number" do
      let(:resources) { state.find_resource("aws_instance.web") }

      it "returns the correct resources" do
        expect(resources.size).to eq(2)
        expect(resources.first["id"]).to eq("i-1299293e")
        expect(resources[1]["id"]).to eq("i-b69b2b9a")
      end
    end

    context "using a resource_selector with a resource_number" do
      let(:resources) { state.find_resource("aws_instance.web.1") }

      it "returns the correct resources" do
        expect(resources.size).to eq(1)
        expect(resources.first["id"]).to eq("i-b69b2b9a")
      end
    end
  end

  describe "#group_by_host" do
    let(:groups) { state.group_by_host Hash["aws_instance.web", "web"] }

    it "properly groups resources" do
      expect(groups.keys.size).to eq(1)
      expect(groups.keys.first).to eq(:web)
      expect(groups[:web].first["id"]).to eq("i-1299293e")
      expect(groups[:web][1]["id"]).to eq("i-b69b2b9a")
    end
  end
end
