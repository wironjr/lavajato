class StaticPagesController < ApplicationController
    before_action :require_logged_in_user
    def index
        @nome = "Wiron"
    end
end
