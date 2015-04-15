class Page < ActiveRecord::Base

class StaticPage
	def self.find_by_name(name)
		begin
			Page.find_by(name: name) && Page.new(name: "current path", content: File.readlines("app/views/static_pages/#{name}"))
		rescue Errno::ENOENT
			Page.new(name: name, content: "Page not found")
		end
	end
end

end
