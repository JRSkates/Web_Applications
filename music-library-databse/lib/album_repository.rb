require_relative './album'

class AlbumRepository
  def all
    sql = 'SELECT id, title, release_year, artist_id FROM albums'
    result_set = DatabaseConnection.exec_params(sql, [])
     # result_set is a PG::Result object which is an array 
     # of hashes one hash per row in the result set
     albums_array = []

     result_set.each do |record|
       album = Album.new
       album.id = record['id']
       album.title = record['title']
       album.release_year = record['release_year']
       album.artist_id = record['artist_id']

       albums_array << album
     end

     return albums_array

  end

  def find(id)
    # Executes the SQL query:
    # SELECT id, title, release_year, artist_id FROM albums WHERE id = $1;
    sql = 'SELECT id, title, release_year, artist_id FROM albums WHERE id = $1;'
    param = [id]

    result = DatabaseConnection.exec_params(sql, param)

    # Returns a single Album object.
    record = result[0]
    album = Album.new
    album.id = record['id']
    album.title = record['title']
    album.release_year = record['release_year']
    album.artist_id = record['artist_id']

    return album
  end

  def create(album)
    sql = 'INSERT INTO albums (title, release_year, artist_id) VALUES ($1, $2, $3);'
    params = [album.title, album.release_year, album.artist_id]
    # Executes the SQL query
    # INSERT INTO albums (title, release_year) VALUES ($1, $2)
    
    DatabaseConnection.exec_params(sql, params)

    # No return value, creates the record on database
  end

  def delete(id)
    sql = 'DELETE FROM albums WHERE id = $1;'
    param = [id]

    DatabaseConnection.exec_params(sql, param)
    # Executes the SQL query
    # DELETE FROM albums WHERE id = $1

    return nil
    #No return value, deletes the record on database
  end

  def update(album)
    # Executes the SQL query
    sql = 'UPDATE albums SET title = $1, release_year = $2 WHERE id = $3;'
    param = [album.title, album.release_year, album.id]

    DatabaseConnection.exec_params(sql, param)
    return nil
    # No return value, updates the record on database
  end
end
