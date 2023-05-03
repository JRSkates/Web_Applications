require_relative '../app'

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

=begin
RSpec.describe Application do
  before(:each) do 
    reset_albums_table
    reset_artists_table
  end

  it 'prints the menu and prints a list of albums' do
      io = double :io
      expect(io).to receive(:puts).with("Welcome to the music library manager!\n \nWhat would you like to do?\n1 - List all albums\n2 - List all artists\n\nEnter your choice:").ordered
      expect(io).to receive(:gets).and_return("1").ordered
      expect(io).to receive(:puts).with("\nHere is your list of albums").ordered
      expect(io).to receive(:puts).with("* 1 - Bossanova").ordered
      expect(io).to receive(:puts).with("* 2 - Surfer Rosa").ordered

      app = Application.new('music_library_test', io, AlbumRepository.new, "artist_repo_dummy") # ArtistRepository.new)


      app.run
  end

  it 'prints the menu and prints a list of artists' do
    io = double :io
    expect(io).to receive(:puts).with("Welcome to the music library manager!\n \nWhat would you like to do?\n1 - List all albums\n2 - List all artists\n\nEnter your choice:").ordered
    expect(io).to receive(:gets).and_return("2").ordered
    expect(io).to receive(:puts).with("\nHere is your list of artists").ordered
    expect(io).to receive(:puts).with("* 1 - Pixies - Rock")
    expect(io).to receive(:puts).with("* 2 - ABBA - Pop")

    app = Application.new('music_library_test', io, AlbumRepository.new, ArtistRepository.new)

    app.run
  end
end
=end