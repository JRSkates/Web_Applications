require_relative 'artist'

class ArtistRepository
  def all 
    sql = 'SELECT id, name, genre FROM artists;'
    result_set = DatabaseConnection.exec_params(sql, [])

    artists_array = []

    result_set.each do |record|
      artist = Artist.new
      artist.id = record['id']
      artist.name = record['name']
      artist.genre = record['genre']

      artists_array << artist
    end

    return artists_array
  end

  def find(id)
    sql = 'SELECT id, name, genre FROM artists WHERE id = $1;'
    param = [id]

    result = DatabaseConnection.exec_params(sql, param)

    record = result[0]
    artist = Artist.new
    artist.id = record['id']
    artist.name = record['name']
    artist.genre = record['genre']
    
    return artist
  end
  
  def create(artist)
    # Executes the SQL query
    # INSERT INTO artists (name, genre) VALUES ($1, $2);
    sql = 'INSERT INTO artists (name, genre) VALUES ($1, $2);'
    params = [artist.name, artist.genre]

    DatabaseConnection.exec_params(sql, params)

    # No return value, creates the record on database
    return nil
  end

  def delete(id)
    # Executes the SQL query
    # DELETE FROM artists WHERE id = $1;
    sql = 'DELETE FROM artists WHERE id = $1;'
    params = [id]

    DatabaseConnection.exec_params(sql, params)

    #No return value, deletes the record on database

    return nil
  end

  def update(artist)
    sql = 'UPDATE artists SET name = $1, genre = $2 WHERE id = $3;'
    param = [artist.name, artist.genre, artist.id]

    DatabaseConnection.exec_params(sql, param)
  end
end