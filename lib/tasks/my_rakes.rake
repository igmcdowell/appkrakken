# RSS formats:
# http://itunes.apple.com/us/rss/topfreeapplications/limit=400/genre=6018/json
# http://itunes.apple.com/us/rss/toppaidapplications/limit=300/genre=6018/json
# http://itunes.apple.com/us/rss/topfreeipadapplications/limit=400/genre=6018/json
# http://itunes.apple.com/us/rss/toppaidipadapplications/limit=400/genre=6018/json
# genre codes: 6000, 6001, 6002, 6003, 6004, 6005, 6006, 6007, 6008, 6009, 6010, 6011, 6012, 6013, 6014, 6015, 6016, 6017, 6018, 6020
# game codes: 7001, 7002, 7003, 7004, 7005, 7006, 7007, 7008, 7009, 7010, 7011, 7012, 7013, 7014, 7015, 7016, 7017, 7018, 7019"

# format for search API: http://itunes.apple.com/lookup?id=322422566

desc "Import apps." 
  task :import_apps => :environment do
    #TODO swap out the static file with feeds from get_feed
    #TODO write some logic to smartly update things at most once per day
    #file = File.open("apps.json", "r:ISO-8859-1") #I'm not sure what the encoding is on Apple's RSS feed. Forcing to read as non-UTF8, then encoding.
    #contents = file.read
    require 'net/http'
    require 'uri'
    contents = Net::HTTP.get URI.parse('http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/toppaidapplications/limit=10/json')
    parsed_json = ActiveSupport::JSON.decode(contents)
    feed = parsed_json["feed"]
    feed["entry"].each do | entry |
      url = entry["id"]["label"]
      idstring = url.split(/\//).last.split(/\?/).first
      app_id = idstring[2,idstring.length]
      name, description, price, app_id = entry["im:name"]["label"], entry["summary"], entry["im:price"]["attributes"]["amount"], app_id
      a = App.find_or_create_by_app_id(:app_id => app_id, :name => name, :description => description, :price => price)
      a.update_details
      a.save
    end
  end