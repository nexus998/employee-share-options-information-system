class FormulaReferenceController < ApplicationController
    layout 'admin'
    before_action :authenticate_user!
    before_action -> {check_role(:admin)}
    def index

    end
end
