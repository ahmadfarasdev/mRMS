class CoreDemographicsController < ProtectForgeryApplication
  before_action  :authenticate_user!
  before_action :set_core_demographic, only: [:update, :show]

  # POST /core_demographics
  # POST /core_demographics.json
  def create
    @core_demographic = CoreDemographic.new(core_demographic_params)

    respond_to do |format|
      if @core_demographic.save
        url = User.current != current_user ? employee_path(User.current) : edit_user_registration_path
        format.html { redirect_to url, notice: I18n.t(:notice_successful_create) }
      else
        format.html { render :edit }
      end
    end
  end

  def show
    respond_to do |format|
      format.pdf{}
    end
  end

  # PATCH/PUT /core_demographics/1
  # PATCH/PUT /core_demographics/1.json
  def update
    @user = @core_demographic.user
    respond_to do |format|
      if @user.update(core_demographic_update_params)
        format.html { redirect_to @user, notice: I18n.t(:notice_successful_update) }
      else
        format.html { render 'edit' }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_core_demographic
    @core_demographic = CoreDemographic.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def core_demographic_params
    params.require(:core_demographic).permit(CoreDemographic.safe_attributes)
  end

  def core_demographic_update_params
    params.require(:user).permit(User.safe_attributes_with_password_with_core_demographic_without_state)
  end
end
