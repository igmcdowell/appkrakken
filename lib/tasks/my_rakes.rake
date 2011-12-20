# RSS formats:
# http://itunes.apple.com/us/rss/topfreeapplications/limit=400/genre=6018/json
# http://itunes.apple.com/us/rss/toppaidapplications/limit=300/genre=6018/json
# http://itunes.apple.com/us/rss/topfreeipadapplications/limit=400/genre=6018/json
# http://itunes.apple.com/us/rss/toppaidipadapplications/limit=400/genre=6018/json
# genre codes: 6000, 6001, 6002, 6003, 6004, 6005, 6006, 6007, 6008, 6009, 6010, 6011, 6012, 6013, 6014, 6015, 6016, 6017, 6018, 6020
# game codes: 7001, 7002, 7003, 7004, 7005, 7006, 7007, 7008, 7009, 7010, 7011, 7012, 7013, 7014, 7015, 7016, 7017, 7018, 7019"

# format for search API: http://itunes.apple.com/lookup?id=322422566
require 'net/http'
require 'uri'

def get_feed(ipad, free, limit, genre)
  padstr = ['','ipad']
  freestr = ['paid', 'free']
  uri = "http://itunes.apple.com/us/rss/top#{freestr[free]}#{padstr[ipad]}applications/limit=#{limit.to_s}/genre-#{genre.to_s}/json"
  feed = Net::HTTP.get URI.parse(uri)
  json = ActiveSupport::JSON.decode(feed)["feed"]
end

def fetch_details(app_id)
  details = Net::HTTP.get URI.parse('http://itunes.apple.com/lookup?id='+app_id)
  details = ActiveSupport::JSON.decode(details)["results"][0]
end

def map_details(details, a)
  price, description = details["price"], details["description"]
  rating, numratings  = details["averageUserRating"], details["userRatingCount"]
  game_url, age_rating, game_center, artwork60, artwork100 = details["trackViewUrl"], details["contentAdvisoryRating"], details["isGameCenterEnabled"], details["artworkUrl60"], details["artworkUrl100"]
  dev_id, dev_site, dev_name  = details["artistId"], details["artistViewUrl"], details["artistName"]
  primary_genre_name, primary_genre_id = details["primaryGenreName"], details["primaryGenreId"]
  size, version, release_notes, release_date = details["fileSizeBytes"], details["version"], details["releaseNotes"], details["releaseDate"]
    a.price, a.description, a.rating, a.numratings, a.game_url, a.age_rating, a.game_center, a.artwork60, a.artwork100, a.dev_id, a.dev_site, a.dev_name, a.primary_genre_name, a.primary_genre_id, a.size, a.version, a.release_notes, a.release_date = price, description, rating, numratings, game_url, age_rating, game_center, artwork60, artwork100, dev_id, dev_site, dev_name, primary_genre_name, primary_genre_id, size, version, release_notes, release_date
  
  genres, genre_codes, ipad_screenshot_urls, language_codes, screenshot_urls, supported_devices = details["genres"], details["genreIds"], details["iPadScreenshotUrls"], details["languageCodesISO2A"], details["screenshot_urls"], details["supportedDevices"]

  if genres
    genres.each do | genre | 
      a.genres.find_or_create_by_name(name: genre)
    end
  end
  if genre_codes
    genre_codes.each do | id | 
      a.genre_codes.find_or_create_by_genre(genre: id)
    end
  end
  if ipad_screenshot_urls
    ipad_screenshot_urls.each do | url |
      a.ipad_screenshot_urls.find_or_create_by_url(url: url)
    end
  end
  if language_codes
    language_codes.each do | code |
      a.language_codes.find_or_create_by_language(language: code)
    end
  end
  if screenshot_urls
    screenshot_urls.each do | url |
      a.screenshot_urls.find_or_create_by_url(url: url)
    end
  end
  if supported_devices
    supported_devices.each do | device |
      a.supported_devices.find_or_create_by_device(device: device)
    end
  end

  return a
end

desc "Import apps." 
  task :import_apps => :environment do
    #TODO swap out the static file with feeds from get_feed
    #TODO write some logic to smartly update things at most once per day
    file = File.open("apps.json", "r:ISO-8859-1") #I'm not sure what the encoding is on Apple's RSS feed. Forcing to read as non-UTF8, then encoding.
    contents = file.read
    contents.encode!("UTF-8")
    parsed_json = ActiveSupport::JSON.decode(contents)
    feed = parsed_json["feed"]
    feed["entry"].each do | entry |
      url = entry["id"]["label"]
      idstring = url.split(/\//).last.split(/\?/).first
      app_id = idstring[2,idstring.length]
      details = fetch_details(app_id)
      name, description, price, app_id = entry["im:name"]["label"], entry["summary"], entry["im:price"]["attributes"]["amount"], app_id
      a = App.find_or_create_by_app_id(:app_id => app_id, :name => name, :description => description, :price => price)
      a = map_details(details, a)
      a.save
    end
  end