class GithubUpdater < CommonUpdater


  def update project, send_email = false
    project.parsing_errors = []
    token = fetch_token_for project
    project_file = fetch_project_file project, token
    if project_file.to_s.strip.empty?
      message = "Project could not be parsed from the GitHub API. Please make sure that the credentials are still valid and the repository still exists."
      log.error message
      store_parsing_errors project, message
      return nil
    end

    new_project = parse project_file, token
    update_old_with_new project, new_project, send_email
  rescue => e
    log.error "ERROR occured by parsing project from GitHub API - #{e.message}"
    log.error e.backtrace.join("\n")
    message = "Project could not be parsed from the GitHub API. Please make sure that the credentials are still valid and the repository still exists. - #{e.message}"
    store_parsing_errors project, message
  end


  def fetch_token_for project
    user = user_for project
    user.github_token
  end


  def fetch_project_file project, token
    filename = project.filename
    filename = 'pom.xml' if filename.eql? 'pom.json'
    Github.fetch_project_file_from_branch project.scm_fullname, filename, project.scm_branch, token
  end


  def parse project_file, token = nil
    content   = GitHubService.pure_text_from project_file
    file_name = GitHubService.filename_from project_file
    parser    = parser_for file_name
    parse_content parser, content, file_name, token
  end


end
