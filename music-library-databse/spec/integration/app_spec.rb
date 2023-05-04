require "spec_helper"
require "rack/test"
require_relative '../../app'

def reset_albums_table
  seed_sql = File.read('spec/seeds_albums.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

def reset_artists_table 
    seed_sql = File.read('spec/seeds_artists.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
    connection.exec(seed_sql)
end

describe Application do
  include Rack::Test::Methods

  let(:app) {Application.new}

  before(:each) do 
    reset_albums_table
    reset_artists_table
  end

  context 'GET /' do
    it 'should return 200 and correct body' do
      response = get('/')

      expect(response.status).to eq 200
      expect(response.body).to include '<title>Skates Music Library Database</title>'
    end
  end

  context 'GET /albums' do
    it 'should return 200 and a list of albums HTML ERB' do
      response = get('/albums')
      expected = 'Bossanova, Surfer Rosa'
  
      expect(response.status).to eq(200)
      expect(response.body).to include '<h1>Albums</h1>'
      expect(response.body).to include 'Title: Bossanova'
      expect(response.body).to include 'Released: 1999'
      expect(response.body).to include '<a href="/albums/1">'
      expect(response.body).to include '<a href="/albums/2">' 
    end
  end

  context 'GET /artists' do
    it 'should return 200 and a list of artists HTML ERB' do
      response = get('/artists')
      expected = 'Pixies, ABBA'

      expect(response.status).to eq(200)
      expect(response.body).to include '<h1>Artists</h1>'
      expect(response.body).to include 'Name: Pixies'
      expect(response.body).to include 'Genre: Rock'
    
    end
  end

  context 'GET /albums/:id' do
    it 'should return 200 and the album with the given id HTML ERB' do
      response = get('/albums/1')
      expected = 'Bossanova'

      expect(response.status).to eq(200)
      expect(response.body).to include '<h1>Bossanova</h1>'
      expect(response.body).to include 'Release year: 1999'
      expect(response.body).to include 'Artist: Pixies'
    end
  end

  context 'GET /aritsts/:id' do
    it 'should return 200 and the artist with the given id HTML ERB' do
      response = get('/artists/1')
      expected = 'Pixies'

      expect(response.status).to eq(200)
      expect(response.body).to include '<h1>Pixies</h1>'
      expect(response.body).to include 'Genre: Rock'
    end
  end

  context "POST /albums" do
    it 'returns 200 OK and our new album is listed with our GET request' do
      response = post(
        '/albums',
        title: 'Let It Be',
        release_year: '1970',
        artist_id: '1'
      )

      expect(response.status).to eq(200)

      response = get('/albums')

      expect(response.status).to eq(200)
      expect(response.body).to include('Let It Be')
    end
  end

  context "POST /artists" do
    it 'returns 200 OK and our new artist is listed withn our GET request' do
      response = post(
        '/artists',
        name: 'The Beatles',
        genre: 'Rock'
      )

      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      response = get('/artists')

      expect(response.status).to eq(200)
      expect(response.body).to include('The Beatles')
    end
  end
end
