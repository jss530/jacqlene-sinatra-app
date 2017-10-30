class Helpers

  def self.current_user(session)
    @user = User.find(session[:id])
    @user
  end

  def self.is_logged_in?(session = {})
    if session[:id] != nil
      return true
    else
      return false
    end
  end
end
