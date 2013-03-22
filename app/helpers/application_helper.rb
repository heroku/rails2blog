# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	include TagsHelper

	def url_for_post(post)
		post_url({
			:year => post.year,
			:month => post.month,
			:day => post.day,
			:slug => post.slug
		}) + '/'
	end

	def post_tag_links(post)
		links = []
		post.tag_list.each do |tag|
			links << link_to(tag, tag_url({:tag => tag}))
		end
		links.join(', ')
	end

	def post_tag_cloud
		return unless defined?(@blog)

		html = []
		
		tag_cloud(@blog.post_cloud_tags, %w(cloud1 cloud2 cloud3 cloud4 cloud5 cloud6)) do |tag, css_class|
			html << link_to(tag.name, tag_url({:tag => tag.name}), { :class => css_class })
		end

		html.join(' ')
	end

	def archives_structure_linked(posts, start_header_level = 3, use_li = false)
		cy = 0
		cm = 0
		closed_y = true
		closed_m = true
		keep_month = ''
		keep_year = ''

		ot  = (use_li ? '<ul>' : '<dt>')
		otc = (use_li ? '</ul>' : '</dt>')
		it  = (use_li ? '<li>' : '<dd>')
		itc = (use_li ? '</li>' : '</dd>')

		output = ''
		for p in posts
			if keep_year != p.created_at.year
				if cy != 0
					output << otc
					closed_y = true
					cy = 0
				end
				output << "#{ot}#{it}<h#{start_header_level}>#{p.created_at.year}</h#{start_header_level}>#{itc}"
				closed_y = false
			end
			if keep_month != p.created_at.month
				if cm != 0
					output << otc
					closed_m = true
					cm = 0
				end
				output << "#{ot}#{it}<h#{(start_header_level+1)}>#{p.created_at.strftime('%B')}</h#{(start_header_level+1)}>#{itc}"
				closed_m = false
			end
			output << "#{it}<a href=\"#{url_for_post(p)}\" title=\"#{p.title}\">#{p.title}</a>#{itc}"

			keep_month = p.created_at.month
			keep_year = p.created_at.year
			cy += 1
			cm += 1
		end
		return output + (!closed_y ? otc : '') + (!closed_m ? otc : '')
	end
end
