module Gcaldis
  class GoogleClient
    require 'google/apis/calendar_v3'
    require 'googleauth'
    require 'googleauth/stores/file_token_store'
    require 'fileutils'

    attr_reader :calendars, :calendar_id
    
    OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
    APPLICATION_NAME = 'Gcaldis'
    CLIENT_SECRETS_PATH = File.join(Dir.home, '.credentials', 'gcaldis', 'client_secret.json')
    CREDENTIALS_PATH = File.join(Dir.home, '.credentials', 'gcaldis',
                                 "gcaldis_token.yaml")
    SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY

    CALENDAR_NAME_PATH = File.join(Dir.home, '.credentials', 'gcaldis', 'calendar_name.yml')
    
    def initialize
      # Initialize the Google Calendar API
      @service = Google::Apis::CalendarV3::CalendarService.new
      @service.client_options.application_name = APPLICATION_NAME
      @service.authorization = authorize
      @calendars= YAML.load(File.read CALENDAR_NAME_PATH)
      @calendar_id=@calendars['andy']
    end
    
    
    ## Taken from Google Calendar API Quickstart
    # Ensure valid credentials, either by restoring from the saved credentials
    # files or intitiating an OAuth2 authorization. If authorization is required,
    # the user's default browser will be launched to approve the request.
    #
    # @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
    def authorize
      FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))
    
      client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
      token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
      authorizer = Google::Auth::UserAuthorizer.new(
        client_id, SCOPE, token_store)
      user_id = 'default'
      credentials = authorizer.get_credentials(user_id)
      if credentials.nil?
        url = authorizer.get_authorization_url(
          base_url: OOB_URI)
        puts "Open the following URL in the browser and enter the " +
             "resulting code after authorization"
        puts url
        code = gets
        credentials = authorizer.get_and_store_credentials_from_code(
          user_id: user_id, code: code, base_url: OOB_URI)
      end
      credentials
    end


    def get_events
      # Fetch the next 10 events for the user

      response = @service.list_events(@calendar_id,
                                     max_results: 10,
                                     single_events: true,
                                     order_by: 'startTime',
                                     time_min: Time.now.iso8601)
      
      puts "Upcoming events:"
      puts "No upcoming events found" if response.items.empty?
      response.items.each do |event|
        start = event.start.date || event.start.date_time
        puts "- #{event.summary} (#{start})"
      end
      return response.items.length
    end
    
    def events_for_week(date=Date.today)
      start_day=(date-date.wday)
      response = @service.list_events(@calendar_id,
                                       max_results: 100,
                                       single_events: true,
                                       order_by: 'startTime',
                                       time_min: start_day.to_time.iso8601,
                                       time_max: (start_day+7).to_time.iso8601)
      response.items
    end
    
    
    
  end
  
end