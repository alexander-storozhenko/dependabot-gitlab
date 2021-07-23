# DependabotGitlab
## Useful Dependabot::Core wrapper for gitlab
### Install
``` gem install 'dependabot_gitlab' ```

or in your Gemfile

``` gem 'dependabot_gitlab' ```

### Example

```ruby
require 'dependabot_gitlab'

credentials = [
    {
        "username" => "x-access-token", # or username 
        "password" => "**** Github access token or password ****"
    },
    {
        "username" => "storozhenko",
        "password" => '****** GitLab access token with API permission *******' 
    }
]

settings = {
    repo: 'repo/repo',
    dir: '/',
    branch: 'master',
    pkg_manager: 'bundler',
    assignees: nil,
}

updater = DependabotGitlab::Updater.new(credentials, settings)
updater.update_dependencies create_merge_request: true

```
