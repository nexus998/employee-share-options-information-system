class OptionsProfileMapsController < ApplicationController
    layout 'admin'
    before_action :authenticate_user!
    before_action -> {check_role(:admin)}

    def index

    end

    def new

    end

    def import
        file = params[:mapping_file]
        OptionsProfileMap.import(file)
        redirect_to options_profiles_path, notice: t('notices.imported')
    end

    def remove_all
        OptionsProfileMap.delete_all
        flash[:notice] = t('notices.destroy')
        redirect_to options_profile_mapping_new_url
    end
end