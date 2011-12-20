class App < ActiveRecord::Base
  has_many :prices, dependent: :destroy, foreign_key: "app_id", :order => "start_date DESC"
  has_many :genres, dependent: :destroy, foreign_key: "app_id"
  has_many :genre_codes, dependent: :destroy, foreign_key: "app_id"
  has_many :ipad_screenshot_urls, dependent: :destroy, foreign_key: "app_id"
  has_many :language_codes, dependent: :destroy, foreign_key: "app_id"
  has_many :screenshot_urls, dependent: :destroy, foreign_key: "app_id"
  has_many :supported_devices, dependent: :destroy, foreign_key: "app_id"
  after_create :add_price_history
  after_save :check_price_change
  

  
  def add_price_history
    if prices.length > 0 
      oldp = self.old_price
      oldp.end_date = DateTime.current()
      oldp.save
    end
    self.prices.create(price: self.price, start_date:DateTime.current())
    #note: self. this point self.query for self.prices.first will return old_price, instead of the new one, since it hits the cache. Not sure how to force it to issue self.fresh query. May only matter in the console
  end
  
  def check_price_change
    if prices.length > 0 and (prices.first.price != price)
     add_price_history
    end
  end
  
  def old_price
    prices.first
  end

  # I could use find_or_create_by_<attr>, but that generates a separate sql query for each candidate. In the most common case (no update), that's going to generate a mess of extra sql queries. Update many relation does 1 query then checks it against candidates and only creates/destroys as necessary.
  def update_many_relation(rel, identifier, candidates)
    existing_relations = eval("self.#{rel}")
    existing_ids = existing_relations.map {| trel | eval("trel.#{identifier}")}.compact
    new_ids = candidates-existing_ids
    deleted_ids = existing_ids - candidates
    new_ids.each do | val |
      eval("#{rel}.create(#{identifier}: '#{val}')")
    end
    deleted_ids.each do | val |
      eval(  "#{rel}.where(#{identifier}: '#{val}')[0].destroy"  )
    end
  end
  
  def update_details(details)
    require 'net/http'
    require 'uri'
    details = Net::HTTP.get URI.parse('http://itunes.apple.com/lookup?id='+app_id.to_s)
    details = ActiveSupport::JSON.decode(details)["results"][0]
    #note: I'm unable to determine which attributes can only change on a resubmission. 
    #since I've already pulled all of them in the search result, it's easiest just to remap everything.
    self.price, self.description = details["price"], details["description"]
    self.rating, self.numratings  = details["averageUserRating"], details["userRatingCount"]
    self.game_url, self.age_rating, self.game_center, self.artwork60, self.artwork100 = details["trackViewUrl"], details["contentAdvisoryRating"], details["isGameCenterEnabled"], details["artworkUrl60"], details["artworkUrl100"]
    self.dev_id, self.dev_site, self.dev_name  = details["artistId"], details["artistViewUrl"], details["artistName"]
    self.primary_genre_name, self.primary_genre_id = details["primaryGenreName"], details["primaryGenreId"]
    self.size, self.version, self.release_notes, self.release_date = details["fileSizeBytes"], details["version"], details["releaseNotes"], details["releaseDate"]
    genres, genre_codes, ipad_screenshot_urls, language_codes, screenshot_urls, supported_devices = details["genres"], details["genreIds"], details["iPadScreenshotUrls"], details["languageCodesISO2A"], details["screenshot_urls"], details["supportedDevices"]
    self.save
    #The has-many relations below require sql queries. Create new relations attempts to tune it a little.
    if genres
      self.update_many_relation('genres', 'name', genres)
    end
    if genre_codes
      genre_codes = genre_codes.map { | gc | gc.to_i}
      self.update_many_relation('genre_codes', 'genre', genre_codes)
    end
    if ipad_screenshot_urls
      self.update_many_relation('ipad_screenshot_urls', 'url', ipad_screenshot_urls)
    end
    if language_codes
      self.update_many_relation('language_codes', 'language', language_codes)
    end
    if screenshot_urls
      self.update_many_relation('screenshot_urls', 'url', screenshot_urls)
    end
    if supported_devices
      self.update_many_relation('supported_devices', 'device', supported_devices)
    end

  end
end
