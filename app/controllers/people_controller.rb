class PeopleController < ApplicationController
  # GET /people
  # GET /people.json
  def index
    @people = Person.page(params[:page]).per(50)
  end

  # GET /people/1
  # GET /people/1.json
  def show
    @person = Person.includes(:contributors => :package).find(params[:id])
  end
end
