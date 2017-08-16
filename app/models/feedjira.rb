require 'feedjira'

class Feedjira

  url = 'https://japan.cnet.com/'

  content = Feedjira::Feed.fetch_and_parse(url)
  binding.pry
  content.entries.each do |entry|
    local_entry = feed.entries.where(title: entry.title).first_or_initialize
    local_entry.update_attributes(content: entry.content, author: entry.author, url: entry.url, published: entry.published)
    p "Synced Entry - #{entry.title}"
  end
  p "Synced Feed - #{feed.name}"

end
