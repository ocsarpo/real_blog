DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")

class Post
  include DataMapper::Resource
  property :id, Serial
  property :writer, String
  property :title, String
  property :body, Text
  property :created_at, DateTime
end

class User
  include DataMapper::Resource
  property :id, Serial
  property :email, String
  property :password, Text
  property :is_admin, Boolean, :default => false
  property :created_at, DateTime
end

DataMapper.finalize

Post.auto_upgrade!
User.auto_upgrade!
