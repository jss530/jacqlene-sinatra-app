module AuthHelpers

  def current_user #=> User instance || nil
    # Memoization
    if @current_user
      @current_user
    else
      @current_user = User.find_by(id: session[:user_id])
    end
  end

  def is_logged_in?
    if current_user
      true
    else
      false
    end
  end
end

# class Auth
#
#   def current_user
#     @current_user
#   end
#
#   def current_user=(user)
#     @current_user = user
#   end
# end
#
# auth = Auth.new
# auth.current_user #=> nil
# auth.current_user = User.create(username: 'lukeghenco')
# auth.current_user  #=> #<User id: 1, username: "lukeghenco">
