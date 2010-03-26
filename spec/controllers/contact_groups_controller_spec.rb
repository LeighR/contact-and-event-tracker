require 'spec_helper'

describe ContactGroupsController do

  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs.merge({:is_admin? => true}))
  end

  def mock_contact(stubs={})
    @mock_user ||= mock_model(Contact, stubs.merge({:name => "bob", :email => 'bob@bob.com'}))
  end

  def mock_contact_group(stubs={})
    @mock_contact_group ||= mock_model(ContactGroup, stubs.merge(:name => "some group"))
  end

  before do
    controller.stub!(:current_user).and_return(mock_user)
  end

  describe "GET index" do
    it "assigns all contact_groups as @contact_groups" do
      ContactGroup.stub!(:find).with(:all).and_return([mock_contact_group])
      get :index
      assigns[:contact_groups].should == [mock_contact_group]
    end
  end

  describe "GET emails" do
    it "redirects if html request" do
      get :emails, :contact_group_ids => ["1"]
      response.should redirect_to(contact_groups_url)
    end

    it "returns emails if json request" do
      mock_contact.should_receive(:email).and_return 'bob@bob.com'
      mock_contact_group.stub!(:contacts).and_return([mock_contact])
      ContactGroup.stub!(:find).and_return([mock_contact_group])
      get :emails, :format => :js, :contact_group_ids => ["1"]
      response.should be_success
      response.body.should == "['bob@bob.com']"
    end
  end

  describe "GET show" do
    it "assigns the requested contact_group as @contact_group" do
      ContactGroup.stub!(:find).with("37").and_return(mock_contact_group)
      get :show, :id => "37"
      assigns[:contact_group].should equal(mock_contact_group)
    end
  end

  describe "GET new" do
    it "assigns a new contact_group as @contact_group" do
      ContactGroup.stub!(:new).and_return(mock_contact_group)
      get :new
      assigns[:contact_group].should equal(mock_contact_group)
    end
  end

  describe "GET edit" do
    it "assigns the requested contact_group as @contact_group" do
      ContactGroup.stub!(:find).with("37").and_return(mock_contact_group)
      get :edit, :id => "37"
      assigns[:contact_group].should equal(mock_contact_group)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created contact_group as @contact_group" do
        ContactGroup.stub!(:new).with({'these' => 'params'}).and_return(mock_contact_group(:save => true))
        post :create, :contact_group => {:these => 'params'}
        assigns[:contact_group].should equal(mock_contact_group)
      end

      it "redirects to the created contact_group" do
        ContactGroup.stub!(:new).and_return(mock_contact_group(:save => true))
        post :create, :contact_group => {}
        response.should redirect_to(contact_group_url(mock_contact_group))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved contact_group as @contact_group" do
        ContactGroup.stub!(:new).with({'these' => 'params'}).and_return(mock_contact_group(:save => false))
        post :create, :contact_group => {:these => 'params'}
        assigns[:contact_group].should equal(mock_contact_group)
      end

      it "re-renders the 'new' template" do
        ContactGroup.stub!(:new).and_return(mock_contact_group(:save => false))
        post :create, :contact_group => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested contact_group" do
        ContactGroup.should_receive(:find).with("37").and_return(mock_contact_group)
        mock_contact_group.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :contact_group => {:these => 'params'}
      end

      it "assigns the requested contact_group as @contact_group" do
        ContactGroup.stub!(:find).and_return(mock_contact_group(:update_attributes => true))
        put :update, :id => "1"
        assigns[:contact_group].should equal(mock_contact_group)
      end

      it "redirects to the contact_group" do
        ContactGroup.stub!(:find).and_return(mock_contact_group(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(contact_group_url(mock_contact_group))
      end
    end

    describe "with invalid params" do
      it "updates the requested contact_group" do
        ContactGroup.should_receive(:find).with("37").and_return(mock_contact_group)
        mock_contact_group.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :contact_group => {:these => 'params'}
      end

      it "assigns the contact_group as @contact_group" do
        ContactGroup.stub!(:find).and_return(mock_contact_group(:update_attributes => false))
        put :update, :id => "1"
        assigns[:contact_group].should equal(mock_contact_group)
      end

      it "re-renders the 'edit' template" do
        ContactGroup.stub!(:find).and_return(mock_contact_group(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested contact_group" do
      ContactGroup.should_receive(:find).with("37").and_return(mock_contact_group)
      mock_contact_group.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the contact_groups list" do
      ContactGroup.stub!(:find).and_return(mock_contact_group(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(contact_groups_url)
    end
  end
end