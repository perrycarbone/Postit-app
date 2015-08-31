class User < ActiveRecord::Base
  include Sluggable

  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create, length: {minimum: 5}
  validates :time_zone, presence: true

  sluggable_column :username

  def two_factor_auth?
    !self.phone.blank?
  end

  def generate_pin!
    self.update_column(:pin, rand(10 ** 6))
  end

  def remove_pin!
    self.update_column(:pin, nil)
  end

  def send_pin_to_twilio
    account_sid = 'AC3d71a7bf6549458801016c6458c4bb64' 
    auth_token = 'f14c502cad0abc2ca4d33667bbcfeb43' 
     
    # set up a client to talk to the Twilio REST API 
    @client = Twilio::REST::Client.new account_sid, auth_token 
    
    msg = "Please enter the following verification code to log in: #{self.pin}"
    @client.account.messages.create({
      :from => '+15168582294', 
      :to => self.phone, 
      :body => msg,  
    })
  end

  def admin?
    self.role == 'admin'
  end

  def moderator?
    self.role == 'moderator'
  end
  
end
