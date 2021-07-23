# Dependabot::Gitlab
## Useful Dependabot::Core wrapper for gitlab
### Install
``` gem install 'dependabot-gitlab' ```

or in your Gemfile

``` gem 'dependabot-gitlab' ```

### Example

```ruby
require 'dependabot-gitlab'

credentials = [
    {
        "username" => "x-access-token", 
        "password" => "**** ACCESS_TOKEN OR PASSWORD ****"
    },
    {
        "username" => "storozhenko",
        "password" => '*************' # A GitLab access token with API permission
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
