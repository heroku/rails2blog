require File.dirname(__FILE__) + "/../spec_helper"

describe Blog do
	before do
		@blog = Blog.new
	end

	it "returns the blog model for the hostname" do
		Blog.should_receive(:find).with(:first, :conditions => [ "subdomain = ?", "blog.example.com" ]).and_return(@blog)
		Blog.find_from_host("blog.example.com").should == @blog
	end

	it "returns the default blog model if none is found for the hostname" do
		Blog.should_receive(:find).with(:first, :conditions => [ "subdomain = ?", "blog.example.com" ]).and_return(nil)
		@default_blog = Blog.new
		Blog.should_receive(:find).with(:first, :conditions => "is_default=true").and_return(@default_blog)
		Blog.find_from_host("blog.example.com").should == @default_blog
	end
end
