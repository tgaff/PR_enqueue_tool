class PullrequestsController < ApplicationController
  before_action :set_pullrequest, only: [:show, :edit, :update, :destroy]

  # GET /pullrequests
  # GET /pullrequests.json
  def index
    @pullrequests = Pullrequest.all
  end

  # GET /pullrequests/1
  # GET /pullrequests/1.json
  def show
  end

  # GET /pullrequests/new
  def new
    @pullrequest = Pullrequest.new
  end

  # GET /pullrequests/1/edit
  def edit
  end

  # POST /pullrequests
  # POST /pullrequests.json
  def create
    @pullrequest = Pullrequest.new(pullrequest_params)

    respond_to do |format|
      if @pullrequest.save
        format.html { redirect_to @pullrequest, notice: 'Pullrequest was successfully created.' }
        format.json { render action: 'show', status: :created, location: @pullrequest }
      else
        format.html { render action: 'new' }
        format.json { render json: @pullrequest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pullrequests/1
  # PATCH/PUT /pullrequests/1.json
  def update
    respond_to do |format|
      if @pullrequest.update(pullrequest_params)
        format.html { redirect_to @pullrequest, notice: 'Pullrequest was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @pullrequest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pullrequests/1
  # DELETE /pullrequests/1.json
  def destroy
    @pullrequest.destroy
    respond_to do |format|
      format.html { redirect_to pullrequests_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pullrequest
      @pullrequest = Pullrequest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pullrequest_params
      params.require(:pullrequest).permit(:number)
    end
end
