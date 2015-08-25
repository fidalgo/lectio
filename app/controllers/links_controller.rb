class LinksController < ApplicationController
  before_action :authenticate_user!
  before_action :link, only: [:show, :edit, :update, :destroy, :read]

  # GET /links
  # GET /links.json
  def index
    @links = current_user.links
  end

  # GET /links/1
  # GET /links/1.json
  def show
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
    @link = Link.new
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
        # TODO: Refactor this is a shot on Single Responsabily principle
        URLParser.new(@link.url).update_title
        format.html { redirect_to @link, notice: 'Link was successfully created.' }
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
    respond_to do |format|
      if link.update(link_params)
        format.html { redirect_to @link, notice: 'Link was successfully updated.' }
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
    params.require(:link).permit(:url, :title)
  end
end
