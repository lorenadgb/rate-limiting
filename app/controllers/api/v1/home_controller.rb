module Api
  module V1
    class HomeController < ApplicationController
      def index
        render status: :ok
      end
    end
  end
end
