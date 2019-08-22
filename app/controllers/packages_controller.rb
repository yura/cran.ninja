class PackagesController < ApplicationController
  def index
    @packages = Package.where("id < 100")
  end

  def show
    @package = Package.includes(:contributors => :person).find(params[:id])
  end
end
