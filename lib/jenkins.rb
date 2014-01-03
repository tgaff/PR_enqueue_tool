module Jenkins
  class << self
    # JENKINS_URL/job/JOBNAME/build?token=TOKEN
    SERVER = ENV['JENKINS_SERVER'] || "http://oceans-ci01.qa.sc.verticalresponse.com:8080"
    BUILD_PATH = (ENV['JENKINS_JOB'] || '/multipass') + '/build'


    def build_pr(pr_num)
      # note this implementation is vulnerable to testing a different sha then it records
      #   this can occur if a new SHA is pushed in between the time it takes jenkins to start and
      #   we record the sha from the github query in our db
      # convert this to post SHAs instead once we have that implemented in jenkins
      url = server_url + '/' + build_path

      Rails.logger.info("Building PR:#{pr_num}, url:#{url}")
      post_build(url, pr_num)
      sleep 5 # don't flood jenkins
    end

    def post_build(url, pr_num)
      #http = Curl.post(url, { PR_NUMBER: pr_num } )
      http = Curl::Easy.http_post(url, jenkins_jsonify( 'PR_NUMBER' => pr_num ))


      puts http.body_str
      unless http.response_code == 200
        handle_post_error(http, url, pr_num)
      end
      Rails.logger.info("POST for pr_num:#{pr_num}, received: #{http.response_code}")
    end

    def jenkins_jsonify(params={})
      # where params is a hash of names and values
      #  { name1: 'asdf', name2: 'kdjfd', foo: 'bar', number: 33 }
      param_array = []
      params.each { |k,v| param_array << {'name' => k.to_s, 'value' => v.to_s } }
      { 'parameter' => param_array }.to_json
    end

    private

    def handle_post_error(curl_obj, url, pr_num)
      puts "Oh No! Failed to build #{pr_num}"
      Rails.logger.error("Failed post build for pr_num=#{pr_num}, http_code:#{curl_obj.response_code}")
    end

    def server_url
      SERVER
    end

    def build_path
      BUILD_PATH
    end
  end
end
