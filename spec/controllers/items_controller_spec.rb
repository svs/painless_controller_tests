require 'spec_helper'

shared_examples "authorised index" do |user, items|
  describe "index" do
    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
      get :index
    end
    it "should assign proper items" do
      assigns[:items].to_a.should =~ items
    end
    it "should respond ok" do
      response.should be_ok
    end
  end
end

shared_examples "authorised action" do
  before :each do
    action.call
  end

  it "should assign proper items" do
    if defined?(variable)
      variable.each do |k,v|
        assigns[k].should v.call
      end
    end
  end

  it "should satisfy expectations" do
    if defined?(expectations)
      expectations.each do |e|
        expect(action).to (e.call)
      end
    end
  end

  it "should render proper template/ redirect properly" do
    response.should redirect_to(redirect_url) if defined?(redirect_url)
    response.should render_template(template) if defined?(template)
  end

end


describe ItemsController do
  context "unauthorised" do
    before :all do
      @item = FactoryGirl.create(:item)
    end
    before :each do
      Ability.any_instance.stubs(:can?).returns(false)
    end

    it "does not index" do
      expect {get :index}.to raise_error CanCan::Unauthorized
    end
    it "does not new" do
      expect {get :new}.to raise_error CanCan::Unauthorized
    end
    it "does not show" do
      expect {get :show, {:id => @item.id}}.to raise_error CanCan::Unauthorized
    end
    it "does not edit" do
      expect {get :edit, {:id => @item.id}}.to raise_error CanCan::Unauthorized
    end
    it "does not update" do
      expect {put :update, {:id => @item.id, :item => {}}}.to raise_error CanCan::Unauthorized
    end
  end

  context "authorised" do
    describe "index" do        
      Item.all.destroy!
      @u = FactoryGirl.create(:user)
      @admin = FactoryGirl.create(:admin)
      @tagger = FactoryGirl.create(:tagger)
      @i = FactoryGirl.create(:item, :user => @u)
      @i2 = FactoryGirl.create(:item, :taggable => true)

      it_behaves_like "authorised index", @u, [@i]
      it_behaves_like "authorised index", @admin, Item.all.to_a
      it_behaves_like "authorised index", @tagger, [@i2]
    end 

    describe "other actions" do
      
      before :each do
        controller.stubs(:current_user => @user)
        Ability.any_instance.stubs(:can?).returns(true)
        @item = FactoryGirl.create(:item)
      end

      describe "new" do
        it_should_behave_like "authorised action" do
          let(:action) { Proc.new {post :new } }
          let(:variables) { {:item => Proc.new{be_a_new(Item)}} }
          let(:template) { :new }
        end
      end

      describe "show" do
        it_should_behave_like "authorised action" do
          let(:action) { Proc.new {post :show, {:id => @item.id} } }
          let(:variables) { {:item => lambda{ eq @item} } }
          let(:template) { :show }
        end
      end
      
      describe "edit" do
        it_should_behave_like "authorised action" do
          let(:action) { Proc.new {get :edit, {:id => @item.id} } }
          let(:variables) { {:item => lambda{ eq @item} } }
          let(:template) { :edit }
        end
      end

      describe "update" do
        before :each do
          Item.any_instance.expects(:save).returns(true)
        end
        it_should_behave_like "authorised action" do
          let(:action) { Proc.new {put :update, {:id => @item.id, :item => {}} } }
          let(:variables) { {:item => lambda{ eq @item} } }
          let(:redirect_url) { @item }
        end
      end

      describe "create" do
        it_should_behave_like "authorised action" do
          let(:action) { Proc.new {post :create, {:item => {:user_id => 1}} } }
          let(:variables) { {:item => lambda{ eq @item} } }
          let(:redirect_url) { assigns[:item] }
          let(:expectations) { [
                                lambda{ change(Item, :count).by(1)}
                               ]}
                                
        end
      end

    end
  end
  
end

