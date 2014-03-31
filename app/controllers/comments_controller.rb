class CommentsController < InheritedResources::Base
  before_filter :authenticate_user!
  # load_and_authorize_resource :except => [:show, :index]
  # skip_load_resource :only => [:create]

  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :set_recommendation, only: [:create, :new]

  # GET /recommendations/1/comments
  # GET /recommendations/1/comments.json
  def index
    @comments = current_user.comments
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    # @comment = Comment.new(comment_params)
    @comment = current_user.comments.build(comment_params)
    @comment.recommendation = @recommendation

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @recommendation, notice: 'Comment was successfully created.' }
        format.json { render action: 'show', status: :created, location: @comment }
      else
        format.html { render action: 'new' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def set_recommendation
      @recommendation = Recommendation.find(params[:recommendation_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      # params[:comment]
      params.require(:comment).permit(:content)
    end
end

