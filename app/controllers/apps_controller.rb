class AppsController < ApplicationController
  # GET /apps
  # GET /apps.json
  def index
    n = (params[:n] != nil && [50,params[:n].to_i].min) || 5
    @drops = App.recent_price_drops(n)
    respond_to do |format|
      format.json { render json: @drops.to_json(
        :include => {
           :genres => {
             :only => :name
           },
           :genre_codes => {
             :only => :genre
           },
           :ipad_screenshot_urls => {
              :only => :url
           },
           :language_codes => {
              :only => :language
           },
           :screenshot_urls => {
              :only => :url
           },
           :supported_devices => {
              :only => :device
           },
           :prices => {
             :only => [:price, :start_date, :end_date, :is_decrease]
           }
        })}
    end
  end

  # GET /apps/1
  # GET /apps/1.json
  def show
    @app = App.includes(:prices).where(app_id: params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { 
        # the ugly syntax below is the only way I could get this to work. See this thread: http://www.ruby-forum.com/topic/132229
        render json: @app.to_json(
          :include => {
             :genres => {
               :only => :name
             },
             :genre_codes => {
               :only => :genre
             },
             :ipad_screenshot_urls => {
                :only => :url
             },
             :language_codes => {
                :only => :language
             },
             :screenshot_urls => {
                :only => :url
             },
             :supported_devices => {
                :only => :device
             },
             :prices => {
               :only => [:price, :start_date, :end_date, :is_decrease]
             }
          })
        }
    end
  end

  # GET /apps/new
  # GET /apps/new.json
  def new
    @app = App.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @app }
    end
  end

  # GET /apps/1/edit
  def edit
    @app = App.find(params[:id])
  end

  # POST /apps
  # POST /apps.json
  def create
    @app = App.new(params[:app])

    respond_to do |format|
      if @app.save
        format.html { redirect_to @app, notice: 'App was successfully created.' }
        format.json { render json: @app, status: :created, location: @app }
      else
        format.html { render action: "new" }
        format.json { render json: @app.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /apps/1
  # PUT /apps/1.json
  def update
    @app = App.find(params[:id])

    respond_to do |format|
      if @app.update_attributes(params[:app])
        format.html { redirect_to @app, notice: 'App was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @app.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /apps/1
  # DELETE /apps/1.json
  def destroy
    @app = App.find(params[:id])
    @app.destroy

    respond_to do |format|
      format.html { redirect_to apps_url }
      format.json { head :ok }
    end
  end
end
