require "bundler"
require "json"

Bundler.require

class App < Sinatra::Application
  configure do
    disable :method_override
    disable :static

    Librato::Metrics.authenticate ENV["LIBRATO_EMAIL"], ENV["LIBRATO_API_KEY"]
  end

  post "/annotate/:name" do
    payload = JSON.parse(params[:payload])
    puts payload.inspect
    state = payload["deployment_status"]["state"]

    if state != "pending"
      repo = payload["repository"]["full_name"]
      creator = payload["deployment"]["creator"]["login"]
      start_time = Time.parse(payload["deployment"]["created_at"])
      end_time = Time.parse(payload["deployment_status"]["created_at"])

      sha = payload["deployment"]["sha"]
      ref = payload["deployment"]["ref"]
      log_url = payload["deployment_status"]["target_url"]

      links = [{
        rel: "github",
        label: "GitHub Commit",
        href: "https://github.com/#{repo}/commit/#{sha}"
      }]

      if log_url && !log_url.empty?
        links << {
          rel: "heaven",
          label: "Heaven Deployment Log",
          href: log_url
        }
      end

      Librato::Metrics.annotate ENV["ANNOTATION_NAME"], "#{ref}",
        start_time: start_time, end_time: end_time,
        description: "#{creator} deployed #{sha}",
        links: links, source: params[:name]
        return 200
    else
      return 404
    end
  end
end
