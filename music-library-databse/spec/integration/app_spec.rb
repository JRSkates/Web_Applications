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

  context 'GET /albums' do
    it 'should return a list of albums' do
      response = get('/albums')
      expected = 'Bossanova, Surfer Rosa'
  
      expect(response.status).to eq(200)
      expect(response.body).to eq expected
    end
  end

  context 'GET /artists' do
    it 'should return a list of artists' do
      response = get('/artists')
      expected = 'Pixies, ABBA'

      expect(response.status).to eq(200)
      expect(response.body).to eq expected
    end
  end
end
