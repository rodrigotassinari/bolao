require 'spec_helper'

# Controller virtual de teste
class ApplicationTestController < ApplicationController
  before_filter :require_user, :only => [:needs_login]
  before_filter :require_no_user, :only => [:needs_no_login]

  def needs_login
    render :text => "OK #{current_user.login}"
  end

  def does_not_need_login
    render :text => "OK"
  end

  def needs_no_login
    render :text => "OK anonymous"
  end

end

describe ApplicationTestController do

  #Delete this example and add some real ones
  it "should use ApplicationTestController" do
    controller.should be_an_instance_of(ApplicationTestController)
  end

  describe "GET /needs_login" do
    fixtures :users
    context "when logged in" do
      before(:each) do
        @user = users(:paid_user)
        activate_authlogic
        UserSession.create(@user)
      end
      it "should succeed" do
        get :needs_login
        response.should be_success
        response.body.should == "OK #{@user.login}"
      end
    end
    context "when not logged in" do
      it "should not succeed" do
        get :needs_login
        response.should_not be_success
      end
      it "should set a notice in the flash" do
        get :needs_login
        flash[:notice].should_not be_blank
      end
      it "should redirect to login page" do
        get :needs_login
        response.should be_redirect
        response.should redirect_to(login_path)
      end
    end
  end

  describe "GET /does_not_need_login" do
    fixtures :users
    context "when logged in" do
      before(:each) do
        @user = users(:paid_user)
        activate_authlogic
        UserSession.create(@user)
      end
      it "should succeed" do
        get :does_not_need_login
        response.should be_success
      end
    end
    context "when not logged in" do
      it "should succeed" do
        get :does_not_need_login
        response.should be_success
      end
    end
  end

  describe "GET /needs_no_login" do
    fixtures :users
    context "when logged in" do
      before(:each) do
        @user = users(:paid_user)
        activate_authlogic
        UserSession.create(@user)
      end
      it "should not succeed" do
        get :needs_no_login
        response.should_not be_success
      end
      it "should set a notice in the flash" do
        get :needs_no_login
        flash[:notice].should_not be_blank
      end
      it "should redirect to root page" do
        get :needs_no_login
        response.should be_redirect
        response.should redirect_to(root_path)
      end
    end
    context "when not logged in" do
      it "should succeed" do
        get :needs_no_login
        response.should be_success
      end
    end
  end

end
