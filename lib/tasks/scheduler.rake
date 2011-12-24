#This task is intended to update the 500 least recently updated apps.
desc "Update apps"
  task :update_apps => :environment do
    to_update = App.find(:all, :limit => 500, :order=> 'updated_at asc')
    to_update.each do | app |
      app.update_details
    end
    puts 'Updated Apps'
  end

desc "Import apps." 
  task :import_apps => :environment do
    require 'net/http'
    require 'uri'
    genre_codes = ["6000", "6001", "6002", "6003", "6004", "6005", "6006", "6007", "6008", "6009", "6010", "6011", "6012", "6013", "6015", "6016", "6017", "6018", "6020", "7001", "7002", "7003", "7004", "7005", "7006", "7007", "7008", "7009", "7010", "7011", "7012", "7013", "7014", "7015", "7016", "7017", "7018", "7019"]
    categories = ["topfreeapplications", "toppaidapplications", "topfreeipadapplications", "toppaidipadapplications"]
    cat_genres = categories.product(genre_codes)
    cat_genres.each do | cat_genre |
      uri = "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/#{cat_genre[0]}/limit=400/genre=#{cat_genre[1]}/json"
      contents = Net::HTTP.get URI.parse(uri)
      parsed_json = ActiveSupport::JSON.decode(contents)
      feed = parsed_json["feed"]
      feed["entry"].each do | entry |
        url = entry["id"]["label"]
        idstring = url.split(/\//).last.split(/\?/).first
        app_id = idstring[2,idstring.length]
        name, description, price, app_id = entry["im:name"]["label"], entry["summary"], entry["im:price"]["attributes"]["amount"], app_id
        a = App.find_or_create_by_app_id(:app_id => app_id, :name => name, :description => description, :price => price)
        a.save
      end
    end
  end