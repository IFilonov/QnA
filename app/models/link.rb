class Link < ApplicationRecord
  GIST_HOST = "gist.github.com"
  DESCRIPTION = 1

  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: { with: URI.regexp, message: 'invalid format' }

  def gist?
    URI(url).host == GIST_HOST
  end

  def gist_content
    client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
    client.gist(url.split("/").last).files.first[DESCRIPTION].content
  end
end
