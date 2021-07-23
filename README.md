# Dependabot::Gitlab
## Useful Dependabot::Core wrapper for gitlab
### Example

```ruby
require 'dependabot-gitlab'

credentials = [
    {
        "type" => "git_source",
        "host" => "github.com",
        "username" => "x-access-token", 
        "password" => "**** ACCESS_TOKEN OR PASSWORD ****"
    }
]

settings = {
    repo: 'repo/repo',
    dir: '/',
    branch: 'master',
    pkg_manager: 'bundler',
    assignees: nil,
}

updater = Dependabot::Gitlab::Updater.new(credentials, settings)
updater.update_dependencies create_merge_request: true

```