namespace :sync do
  desc 'Ensures DB records of pages in app/views/static_pages'
  task :static_page_records => :environment do
    Dir.foreach('app/views/static_pages') do |item|
      next if item == '.' or item == '..'
      unless Page.find_by(name: item)
        Page.create(name: item)
      end
    end
  end
end
