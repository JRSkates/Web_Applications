require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  # This allows the app code to refresh
  # without having to restart the server.
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get '/' do
    return erb(:home)
  end

  get '/albums' do
    repo = AlbumRepository.new
    @albums = repo.all

    return erb(:albums)
  end

  get '/albums/new' do
    return erb(:new_album)
  end

  get '/artists/new' do
    return erb(:new_artist)
  end

  get '/artists' do
    repo = ArtistRepository.new
    @artists = repo.all

    return erb(:artists)
  end


  get '/albums/:id' do
    alb_repo = AlbumRepository.new
    art_repo = ArtistRepository.new
    album_id = params[:id]

    album = alb_repo.find(album_id)
    artist_id = album.artist_id
    artist = art_repo.find(artist_id)

    @title = album.title
    @release_year = album.release_year
    @artist = artist.name

    return erb(:album)
  end

  get '/artists/:id' do
    repo = ArtistRepository.new
    artist_id = params[:id]
    artist = repo.find(artist_id)
    @name = artist.name
    @genre = artist.genre
    return erb(:artist)
  end
  

  post '/albums' do
    if invalid_album_request_params?
      status 400
      return ''
    end
    repo = AlbumRepository.new
    new_album = Album.new
    new_album.title = params[:title]
    new_album.release_year = params[:release_year]
    new_album.artist_id = params[:artist_id]
    @title = new_album.title
    repo.create(new_album)

    return erb(:post_albums)
  end

  post '/artists' do
    if invalid_artist_request_params?
      status 400
      return ''
    end

    repo = ArtistRepository.new
    new_artist = Artist.new
    new_artist.name = params[:name]
    new_artist.genre = params[:genre]
    @name = new_artist.name
    repo.create(new_artist)

    return erb(:post_artists)
  end

  private

  def invalid_album_request_params?
    params[:title] == nil || 
    params[:release_year] == nil || 
    params[:artist_id] == nil
  end

  def invalid_artist_request_params?
    params[:name] == nil ||
    params[:genre] == nil
  end
end