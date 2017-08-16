class Scraping
  @@agent = Mechanize.new
  def self.movie_urls
    links = []
    next_url = ""

    while true
      current_page = @@agent.get("http://review-movie.herokuapp.com/" + next_url)
      elements = current_page.search('.entry-title a')
      elements.each do |ele|
        links << ele[:href]
      end

      next_link = current_page.at('.pagination .next a')
      break unless next_link
      next_url = next_link[:href]
    end
    links.each do |link|
      get_product('http://review-movie.herokuapp.com' + link)
    end
  end

  # 引数で与えられたurlのタイトル、イメージurlを取得してすでにレコードがあれば更新、なければ新しく作成するメソッド
  def self.get_product(link)
    page = @@agent.get(link)
    title = page.at('.entry-title').inner_text if page.at('.entry-title')
    image_url = page.at('.entry-content img')[:src] if page.at('.entry-content img')
    product = Product.where(title: title).first_or_initialize
    product.image_url = image_url
    product.save
  end
end
