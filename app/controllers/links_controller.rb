class LinksController < ApplicationController
  before_action :authenticate_user!
  before_action :link, only: [:show, :edit, :update, :destroy, :read]

  # GET /links
  # GET /links.json
  def index
    @links = current_user.links.order(read: :asc).order(created_at: :desc).page params[:page]
    redirect_to page_path('help') if @links.empty?
  end

  # GET /tags/#{query}.json
  def tags
    if params[:query].present?
      # TODO: Check for possible SQLi here
      render json: current_user.tags.where('name LIKE ?', "%#{params[:query]}%")
    else
      render json: current_user.tags
    end
end

  def read
    link.read = link.read ? false : true
    respond_to do |format|
      if link.save
        flash.notice = "The link was marked as #{link.status}!"
        format.js {}
      end
    end
  end

  # GET /links/new
  def new
    logger.info params
    @link = Link.new(url: params[:url])
  end

  # GET /links/1/edit
  def edit
  end

  # POST /links
  # POST /links.json
  def create
    @link = Link.new(link_params)
    link.user = current_user
    respond_to do |format|
      if link.save
        current_user.tag(@link, link_params['tags_list'])
        format.html { redirect_to links_url, notice: 'Link was successfully created.' }
        format.json { render :show, status: :created, location: @link }
      else
        format.html { render :new }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /links/1
  # PATCH/PUT /links/1.json
  def update
    logger.info "TAGS: #{@link.tags}"
    respond_to do |format|
      if link.update(link_params)
        current_user.tag(@link, link_params['tags_list'])
        UrlScrapperJob.perform_later @link.id
        format.html { redirect_to links_url, notice: 'Link was successfully updated.' }
        format.json { render :show, status: :ok, location: @link }
      else
        format.html { render :edit }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1
  # DELETE /links/1.json
  def destroy
    link.destroy
    respond_to do |format|
      format.html { redirect_to links_url, notice: 'Link was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def link
    @link ||= current_user.links.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def link_params
    params.require(:link).permit(:url, :title, :read, tags_list: [])
  end
end
