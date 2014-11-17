class ProjectUpdateWorker < Worker


  def work
    connection = get_connection
    connection.start
    channel = connection.create_channel
    queue   = channel.queue("project_update", :durable => true)

    log_msg = " [*] Waiting for messages in #{queue.name}. To exit press CTRL+C"
    puts log_msg
    log.info log_msg

    begin
      queue.subscribe(:ack => true, :block => true) do |delivery_info, properties, body|
        msg = " [x] Received #{body}"
        puts msg
        log.info msg

        update_projects msg

        channel.ack(delivery_info.delivery_tag)
      end
    rescue => e
      log.error e.message
      log.error e.backtrace.join("\n")
      connection.close
    end
  end

  def process msg
    if msg.eql?( Project::A_PERIOD_MONTHLY ) || msg.eql?( Project::A_PERIOD_WEEKLY ) || msg.eql?( A_PERIOD_DAILY )
      update_projects msg
    elsif msg.match(/project_/)
      update_project msg
    end
  rescue => e
    log.error e.message
    log.error e.backtrace.join("\n")
  end

  # msg should have these values:
  # - Project::A_PERIOD_DAILY
  # - Project::A_PERIOD_WEEKLY
  # - Project::A_PERIOD_MONTHLY
  #
  def update_projects msg
    ProjectUpdateService.update_all( msg )
  rescue => e
    log.error e.message
    log.error e.backtrace.join("\n")
  end

  def update_project msg
    project_id = msg.gsub("project_", "")
    project = Project.find project_id
    ProjectUpdateService.update project, true
  rescue => e
    log.error e.message
    log.error e.backtrace.join("\n")
  end


end
