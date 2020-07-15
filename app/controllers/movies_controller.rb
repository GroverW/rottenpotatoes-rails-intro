class MoviesController < ApplicationController
  def movie_params
    params.require(:movie).permit(:sort, :title, :rating, :description, :release_date)
  end
  
  helper_method :selected_col?, :selected_rating?

  def selected_col? col; params[:sort] == col.to_s ? 'hilite' : ''; end

  def selected_rating? rating; not params[:ratings] or params[:ratings].key? rating; end

  def update_params path, *keys
    is_malformed = false

    keys.each do |key|
      is_malformed = true if session[key] && (not params[key])
      session[key] = params[key] if params[key]
    end

    if is_malformed
      new_params = keys.map { |key| [key, session[key]] }.to_h
      flash.keep
      redirect_to method(path).call(new_params)
    end
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    update_params :movies_path, :ratings, :sort
    
    @movies = Movie.with_ratings(params[:ratings]).order(params[:sort])
    @all_ratings = Movie.all_ratings
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
