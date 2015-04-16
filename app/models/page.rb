class Page < ActiveRecord::Base
	validates :name, presence: true, allow_blank: false

  def persist_!
    return found_page_response(name) if Page.find_by(name: name)
    file_name = "app/views/static_pages/#{StaticPage.file_name(name)}"
    if File.exists?(file_name)
      return found_file_response(name) 
    end
    File.open(file_name, 'w') { |f| f.write(content) }
    self.save
    true
  end
  
  def found_file_response(name)
    self.content = "A file was already found with that name".red
    true
  end

  def found_page_response(name)
    self.content = "A DB record was already found with that name".red
    true
  end
  
class StaticPage
  def self.file_name(name)
    name.split(" ").map(&:downcase).join("_")
  end
	def self.find_by_name(name)
		begin
			if Page.find_by(name: name)
        Page.new(name: name, content: File.read("app/views/static_pages/#{file_name(name)}"))
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
