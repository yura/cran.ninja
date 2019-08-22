class PackagesController < ApplicationController
  def index
    @packages = Package.page(params[:page]).per(50)
  end

  def show
    @package = Package.includes(:contributors => :person).find(params[:id])
  end
end
