require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Post do
	before(:each) do
		@post = Post.new
		@post.stub!(:id).and_return(123)
		@post.stub!(:blog_id).and_return(1)
		@post.stub!(:connection).and_return(mock("connection"))
	end

	it "sets the slug field based on the id and title" do
		@post.title = "My Blog Entry"
		@post.slug = nil
		@post.connection.should_receive(:quote).with("123_my_blog_entry").and_return("'123_my_blog_entry'")
		@post.connection.should_receive(:execute).with("UPDATE posts SET slug = '123_my_blog_entry' WHERE id=123")
		@post.set_slug
	end

	it "the slug generated should not have 2 consecutive underscores" do
		@post.title = "My Blog & Me"
		@post.slug = nil
		@post.connection.should_receive(:quote).with("123_my_blog_me").and_return("'123_my_blog_me'")
		@post.connection.stub!(:execute)
		@post.set_slug
	end

	it "the slug generated should not have a leading underscore" do
		@post.title = "!My Blog"
		@post.slug = nil
		@post.connection.should_receive(:quote).with("123_my_blog").and_return("'123_my_blog'")
		@post.connection.stub!(:execute)
		@post.set_slug
	end

	it "the slug generated should not have a trailing underscore" do
		@post.title = "My Blog!"
		@post.slug = nil
		@post.connection.should_receive(:quote).with("123_my_blog").and_return("'123_my_blog'")
		@post.connection.stub!(:execute)
		@post.set_slug
	end

	it "commas should be removed from the title before sluggifying it" do
		@post.title = "10,000 Hits!"
		@post.slug = nil
		@post.connection.should_receive(:quote).with("123_10000_hits").and_return("'123_10000_hits'")
		@post.connection.stub!(:execute)
		@post.set_slug
	end

	it "don't set the slug if it already exists" do
		@post.slug = "my_awesome_post"
		@post.connection.should_not_receive(:execute)
		@post.set_slug
	end

	it "parses the raw content" do
		parser = mock("parser")
		RedCloth.stub!(:new).with("h1. My Title").and_return(parser)
		parser.should_receive(:to_html).and_return("<h1>My Title</h1>")

		parser2 = mock("parser2")
		RedCloth.stub!(:new).with("h4. Subtitles").and_return(parser2)
		parser2.should_receive(:to_html).and_return("<h4>Subtitles</h4>")

		Post.should_receive(:strip_html).with("<h1>My Title</h1> <h4>Subtitles</h4>").and_return("My Title Subtitles")

		@post.content_raw = "h1. My Title"
		@post.extended_content_raw = "h4. Subtitles"
		@post.parse_post
		@post.content.should == "<h1>My Title</h1>"
		@post.extended_content.should == "<h4>Subtitles</h4>"
		@post.content_searchable.should == "My Title Subtitles"
	end

	it "strips html from the string" do
		Post.strip_html("<h1>Hello World</h1>").should == "Hello World"
		Post.strip_html("<a href=\"mailto:my@example.com\">my@example.com</a> &mdash; woo").should == "my@example.com -- woo"
	end

	it "finds the next post in relation to the current post" do
		@next_post = mock("next_post")
		@post.stub!(:created_at).and_return("today")
		Post.should_receive(:find).with(:first, :conditions => ['blog_id = ? AND created_at > ?', 1, "today"], :order => "created_at", :limit => 1).and_return(@next_post)
		@post.next_post.should == @next_post
	end

	it "finds the previous post in relation to the current post" do
		@prev_post = mock("prev_post")
		@post.stub!(:created_at).and_return("yesterday")
		Post.should_receive(:find).with(:first, :conditions => ['blog_id = ? AND created_at < ?', 1, "yesterday"], :order => "created_at DESC", :limit => 1).and_return(@prev_post)
		@post.prev_post.should == @prev_post
	end

end
