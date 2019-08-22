class PackagesController < ApplicationController
  def index
    @packages = Package.where("id < 100")
  end
end
