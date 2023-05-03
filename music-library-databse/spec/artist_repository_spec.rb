require 'artist_repository'

RSpec.describe ArtistRepository do

  def reset_artists_table 
    seed_sql = File.read('spec/seeds_artists.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
    connection.exec(seed_sql)
  end

  before(:each) do
    reset_artists_table
  end

  context 'The All Method' do
    it 'returns an array of Artist objects' do
      repo = ArtistRepository.new
      artists = repo.all
  
      expect(artists.length).to eq 2
      expect(artists.first.id).to eq '1'
      expect(artists.first.name).to eq 'Pixies'
    end
  end

  context 'The Find Method' do
    it 'returns a single Artist object' do
      repo = ArtistRepository.new
      artist = repo.find(1)
  
      expect(artist.name).to eq 'Pixies'
      expect(artist.genre).to eq 'Rock'
    end
  end

  context 'The Create Method' do
    it 'creates a new artist at the end of the line' do
      repo = ArtistRepository.new

      artist = Artist.new
      artist.name = 'Fleetwood Mac'
      artist.genre = 'Rock'

      repo.create(artist)

      artists = repo.all
      last_artist = artists.last 

      expect(last_artist.id).to eq '3'
      expect(last_artist.name).to eq 'Fleetwood Mac'
      expect(last_artist.genre).to eq 'Rock'
    end
  end

  context 'The Delete Method' do
    it "deletes the first artist" do
      repo = ArtistRepository.new
      repo.delete(1)
      artists = repo.all
      first_artist = artists.first
      expect(first_artist.id).to eq '2'
      expect(first_artist.name).to eq 'ABBA'
      expect(first_artist.genre).to eq 'Pop'
    end
  end

  context 'The Update Method' do
    it "updates the artist selected" do
      repo = ArtistRepository.new

      original_artist = repo.find(1)
      
      original_artist.name = 'Kendrick Lamar'
      original_artist.genre = 'Hip-Hop'
      
      repo.update(original_artist)
      
      updated_artist = repo.find(1)
      
      expect(updated_artist.name).to eq 'Kendrick Lamar'
      expect(updated_artist.genre).to eq 'Hip-Hop'
    end
  end
end