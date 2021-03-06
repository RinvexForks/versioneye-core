class NotificationMailer < SuperMailer


  def new_version_email(user, notifications)
    @newsletter = "notification_emails"
    @user = user
    @notifications = notifications
    @link =  "#{Settings.instance.server_url}/"
    @user_product_index = ProjectService.user_product_index_map( user )

    names = first_names notifications
    m = mail(:to => @user.email, :subject => "Update: #{names}") do |format|
      format.html{ render layout: 'email_html_layout' }
    end
    set_from( m )
  end


  def status(count)
    @count = count
    m = mail(:to => 'reiz@versioneye.com', :subject => "#{count} notifications") do |format|
      format.html{ render layout: 'email_html_layout' }
    end
    set_from( m )
  end


  private


    def first_names notifications
      names = Array.new
      max = 2
      max = 1 if notifications.size == 2
      max = 0 if notifications.size == 1
      (0..max).each do |num|
        notification = notifications[num]
        names.push notification.product.name
      end
      result = names.join(', ')
      if notifications.size > 3
        result = "#{result} ..."
      end
      result
    end


end
