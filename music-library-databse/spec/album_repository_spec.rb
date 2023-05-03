require 'album_repository'

RSpec.describe AlbumRepository do

  def reset_artists_table 
    seed_sql = File.read('spec/seeds_albums.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
    connection.exec(seed_sql)
  end
  
  before(:each) do
    reset_artists_table
  end
  context 'With the all method' do
    it 'returns all 2 albums' do
      repo = AlbumRepository.new #seeded from our test seed with 2 columns
      albums = repo.all 

      expect(albums.length).to eq 2
      expect(albums.first.release_year).to eq '1999'
      expect(albums.first.title).to eq 'Bossanova'
      expect(albums.first.artist_id ).to eq '1'
    end
  end

  context 'With the find method' do
    it 'Returns a single album' do
      repo = AlbumRepository.new 
      album = repo.find(1)

      expect(album.title).to eq 'Bossanova'
      expect(album.release_year).to eq '1999'
      expect(album.artist_id).to eq '1'
      expect(album.id).to eq '1'
    end

    it 'Returns another album' do
      repo = AlbumRepository.new 
      album = repo.find(2)

      expect(album.title).to eq 'Surfer Rosa'
      expect(album.release_year).to eq '2001'
      expect(album.artist_id).to eq '1'
      expect(album.id).to eq '2'
    end
  end

  context 'With the create method' do
    it 'adds a new album to the database' do
      repo = AlbumRepository.new

      album = Album.new
      album.title = 'Rumours'
      album.release_year = 1977
      album.artist_id = '2'

      repo.create(album) # => nil

      albums = repo.all
      last_album = albums.last 

      expect(last_album.title).to eq 'Rumours'
      expect(last_album.release_year).to eq '1977'
      expect(last_album.artist_id).to eq '2'
    end
  end

  context 'With the delete method' do
    it 'deletes the album from the database' do
      repo = AlbumRepository.new

      repo.delete(1)

      albums = repo.all
      first_album = albums.first

      expect(first_album.title).to eq 'Surfer Rosa'
      expect(first_album.release_year).to eq '2001'
    end
  end

  context 'With the update method' do
    it 'updates the album from the database' do
      repo = AlbumRepository.new

      orginal_album = repo.find(1)
      
      orginal_album.title = 'DAMN'
      orginal_album.release_year = '2017'
      
      repo.update(orginal_album)
      
      updated_album = repo.find(1)

      expect(updated_album.title).to eq 'DAMN'
      expect(updated_album.release_year).to eq '2017'
    end
  end
end