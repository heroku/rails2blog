require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Author do
	before(:each) do
		@author = Author.new
	end

	it "should set the password" do
		@author.stub!(:save!)
		@author.password = nil
		@author.reset_password("mypassword")
		@author.password.should_not be_nil
	end

	it "should find the heroku user by email" do
		Author.should_receive(:find).with(:first, :conditions => [ "email = ?", "dummy@example.com" ]).and_return(@author)
		Author.find_heroku_user('dummy@example.com').should == @author
	end

	it "should create an author record by email if the heroku user doesn't exist" do
		Author.should_receive(:find).with(:first, :conditions => [ "email = ?", "dummy@example.com" ]).and_return(nil)
		Author.should_receive(:create!).with(:email => 'dummy@example.com', :name => 'dummy').and_return(@author)
		Author.find_heroku_user('dummy@example.com').should == @author
	end
end
