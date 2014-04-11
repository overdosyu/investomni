class UserProfilesController < ApplicationController
  before_filter :set_user_profile, only: [:show, :edit, :update]

  def show
    # use map to convert ActiveRecord::Relation to Array
    finalized_rcmds = @user_profile.user.recommendations.where(is_finalize: true).map { |r| r }
    if finalized_rcmds.any?
      success_rcmd_count = 0

      # ex: {:buy=>[#<Recommendation>], :sell=>[#<Recommendation>, #<Recommendation>]}
      rcmds_hash = finalized_rcmds.group_by(&:action)
      buy_rcmds = rcmds_hash[:buy]
      if buy_rcmds
        buy_success_rcmd_count = buy_rcmds.count { |r| r.action == r.result[:action] }
        success_rcmd_count += buy_success_rcmd_count
        @buy_success_percent = (buy_success_rcmd_count.to_f * 100 / buy_rcmds.length).round
      else
        @buy_success_percent = nil
      end

      sell_rcmds = rcmds_hash[:sell]
      if sell_rcmds
        sell_success_rcmd_count = sell_rcmds.count { |r| r.action == r.result[:action] }
        success_rcmd_count += sell_success_rcmd_count
        @sell_success_percent = (sell_success_rcmd_count.to_f * 100 / sell_rcmds.length).round
      else
        @sell_success_percent = nil
      end

      hold_rcmds = rcmds_hash[:hold]
      if hold_rcmds
        hold_success_rcmd_count = hold_rcmds.count { |r| r.action == r.result[:action] }
        success_rcmd_count += hold_success_rcmd_count
        @hold_success_percent = (hold_success_rcmd_count.to_f * 100 / hold_rcmds.length).round
      else
        @hold_success_percent = nil
      end

      @success_percent = (success_rcmd_count.to_f * 100 / finalized_rcmds.length).round
    else  # no finalized recommendation for this user
      @success_percent = nil
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @user_profile.update(user_profile_params)
        format.html { redirect_to @user_profile, notice: 'Profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_profile
      @user_profile = UserProfile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_profile_params
      params.require(:user_profile).permit(:name, :avatar)
    end
end
