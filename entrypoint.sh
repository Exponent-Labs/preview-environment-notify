#!/usr/bin/env ruby

require "json"
require "octokit"

json = File.read(ENV.fetch("GITHUB_EVENT_PATH"))
push = JSON.parse(json)

github = Octokit::Client.new(access_token: ENV["GITHUB_TOKEN"])

if !ENV["GITHUB_TOKEN"]
  puts "Missing GITHUB_TOKEN"
  exit(1)
end

# if ARGV.empty?
#   puts "Missing message argument."
#   exit(1)
# end

if ENV["destroyed"]
  message = "The preview environment has been destroyed."
else
  frontend_url = ENV["FRONTEND_URL"]
  admin_url = ENV["ADMIN_URL"]
  message = "A preview environment has been created.\nFrontend URL: #{frontend_url}\nBackend URL: #{admin_url}"
end

puts "Message: #{message}"

repo = push["repository"]["full_name"]
pulls = github.pull_requests(repo)

push_head = push["after"]
pr = pulls.find { |pr| pr["head"]["sha"] == push_head }

if !pr
  puts "Couldn't find a pull request for branch with head at #{push_head}."
  exit(1)
end

# message = ARGV.join(' ')

coms = github.issue_comments(repo, pr["number"])
duplicate = coms.find { |c| c["user"]["login"] == 'github-actions[bot]' && c["body"] == message }

if duplicate
  puts "The PR already contains a database change notification"
  exit(0)
end

github.add_comment(repo, pr["number"], message)
