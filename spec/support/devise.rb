module ControllerMacros
  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in Factory.create(:admin) # Using factory girl as an example
    end
  end

  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = Factory.create(:customer)
      sign_in user
    end
  end

  def login_scanner
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = Factory.create(:scanner)
      sign_in user
    end
  end

  def login_tagger
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = Factory.create(:tagger)
      sign_in user
    end
  end


end

RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  # config.extend ControllerMacros, :type => :controller
end
