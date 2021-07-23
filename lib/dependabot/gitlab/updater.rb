
require "dependabot/file_fetchers"
require "dependabot/file_parsers"
require "dependabot/update_checkers"
require "dependabot/file_updaters"
require "dependabot/pull_request_creator"
require "dependabot/omnibus"
require 'gitlab'

require_relative 'core_functions'
module Dependabot
  module Gitlab
    class Updater
      def initialize(credentials, settings, verbose: true)
        @credentials = credentials
        @core = CoreFunctions.new(credentials, settings)
        @verbose = verbose
      end

      def update_dependencies(create_merge_request:)
        return dependencies_update_with_timer(create_merge_request) if @verbose

        dependencies_update(create_merge_request)
      end

      private

      def dependencies_update_with_timer(create_merge_request)
        p 'Start dependencies update'
        time = Time.now

        @core.dependencies_info(create_merge_request)

        p "Done (#{Time.now - time })"
      end

      def dependencies_update(create_merge_request)
        @core.dependencies_info(create_merge_request)
      end
    end
  end
end
