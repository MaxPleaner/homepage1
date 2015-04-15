class Page < ActiveRecord::Base

class StaticPage
	def self.find_by_name(name)
		begin
			if Page.find_by(name: name)
				Page.new(name: "current path", content: File.read("app/views/static_pages/#{name}"))
			else
				page_not_found(name, "Not in the DB")
			end	
		rescue Errno::ENOENT
			page_not_found(name, "Not in the filesystem")
		end
	end
	def self.page_not_found(name, extra_message="")
		Page.new(name: name, content: "#{"Page not found".red} #{extra_message}")
	end
end

end
