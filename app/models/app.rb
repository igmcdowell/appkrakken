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
    if self.prices.length > 0 
      oldp = self.old_price
      oldp.end_date = DateTime.current()
      oldp.save
    end
    self.prices.create(price: self.price, start_date:DateTime.current())
    #note: at this point a query for a.prices.first will return old_price, instead of the new one, since it hits the cache. Not sure how to force it to issue a fresh query. May only matter in the console
  end
  
  def check_price_change
    if self.prices.length > 0 and (self.prices.first.price != self.price)
      add_price_history
    end
  end
  
  def old_price
    self.prices.first
  end
end
