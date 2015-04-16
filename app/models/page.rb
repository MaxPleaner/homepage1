class Page < ActiveRecord::Base
	validates :name, presence: true, allow_blank: false

class StaticPage
	def self.find_by_name(name)
		begin
			if Page.find_by(name: name)
				file_name = name.split(" ").map(&:downcase).join("_")
				Page.new(name: name, content: File.read("app/views/static_pages/#{file_name}"))
			else
				page_not_found(name, "Not in the DB")
			end	
		rescue Errno::ENOENT
			awaiting_moderation(name)
		end
	end
	def self.page_not_found(name, extra_message="")
		Page.new(name: name, content: "#{"Page not found".red} #{extra_message}")
	end
	def self.awaiting_moderation(name)
		Page.new(name: name, content: "hidden pending moderator approval".blue)
	end
end

end
