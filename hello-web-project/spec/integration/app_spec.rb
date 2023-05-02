require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  include Rack::Test::Methods

  let(:app) {Application.new}
  
  context 'GET /' do
    it 'returns 200 OK with correct body' do
      response = get('/')

      expect(response.status).to eq 200
      expect(response.body).to eq 'Hello, world!'
    end
  end

  context 'GET /hello' do
    it 'returns 200 OK with correct body' do
      response = get('/hello', name: 'Jack')

      expect(response.status).to eq 200
      expect(response.body).to eq 'Hello, Jack'
    end
  end

  context 'GET /posts' do
    it 'returns 200 OK with correct body' do
      response = get('/posts', name: 'Jack')

      expect(response.status).to eq 200
      expect(response.body).to eq "A list of Jack's posts:"
    end
  end

  context 'POST /posts' do
    it 'returns 200 OK with correct body' do
      response = post('/posts', title: "Jack's Post")

      expect(response.status).to eq 200
      expect(response.body).to eq "Post was created with title: 'Jack's Post'"
    end
  end

  context 'POST /submit' do
    it 'returns 200 OK with correct body' do
      response = post('/submit', name: 'Jack', message: 'Hello World')

      expect(response.status).to eq 200
      expect(response.body).to eq "Thanks Jack, you sent this message: Hello World"
    end
  end

  context "GET /names" do
    it 'returns 200 OK with body' do
      # Assuming the post with id 1 exists.
      response = get('/names')

      expect(response.status).to eq(200)
      expect(response.body).to eq('Julia, Mary, Karim')
    end
  end

  context "POST /sort-names" do
    it 'returns 200 OK with content' do
      # Assuming the post with id 1 exists.
      response = post('/sort-names', names: "Joe,Alice,Zoe,Julia,Kieran")

      expect(response.status).to eq(200)
      expect(response.body).to eq("Alice,Joe,Julia,Kieran,Zoe")
    end
  end
end