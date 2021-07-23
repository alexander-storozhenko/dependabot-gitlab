module Dependabot
  module Gitlab
    class CoreFunctions

      DEFAULT_HOST_NAME = 'gitlab.com'.freeze
      DEFAULT_PROVIDER = 'gitlab'.freeze
      DEFAULT_API_ENDPOINT = 'https://gitlab.com/api/v4'.freeze
      DEFAULT_BRANCH = 'master'.freeze

      def initialize(credentials, settings)
        @settings = settings
        @credentials = credentials
      end

      def dependencies_info(create_merge_request)
        messages = []

        init_source

        file_fetcher = fetcher
        files = file_fetcher.files

        dependencies = parser(files).parse

        commit = file_fetcher.commit

        dependencies.select(&:top_level?).each do |dep|
          checker = checker(files, dep)

          next if checker.up_to_date?

          requirements_to_unlock = unlock_requirements(checker)

          next if requirements_to_unlock == :update_not_possible

          updated_deps = checker.updated_dependencies(
              requirements_to_unlock: requirements_to_unlock
          )

          updater = file_updater(updated_deps, files)
          updated_files = updater.updated_dependency_files

          create_mr(updated_files, updated_deps, commit) if create_merge_request

          messages << {name: dep.name, old_version: dep.version, new_version: updater.dependencies.first.version}
        end

        messages.join
      end

      private

      def init_source
        @source = Dependabot::Source.new(
            provider: @settings[:provider] || DEFAULT_PROVIDER,
            hostname: @settings[:hostname] || DEFAULT_HOST_NAME,
            api_endpoint: @settings[:api_endpoint] || DEFAULT_API_ENDPOINT,
            repo: @settings[:repo],
            directory: @settings[:dir],
            branch: @settings[:branch] || DEFAULT_BRANCH
        )
      end

      def fetcher
        Dependabot::FileFetchers.for_package_manager(@settings[:pkg_manager]).new(
            source: @source,
            credentials: @credentials,
        )
      end

      def parser(files)
        Dependabot::FileParsers.for_package_manager(@settings[:pkg_manager]).new(
            dependency_files: files,
            source: @source,
            credentials: @credentials,
            )
      end

      def checker(files, dep)
        Dependabot::UpdateCheckers.for_package_manager(@settings[:pkg_manager]).new(
            dependency: dep,
            dependency_files: files,
            credentials: @credentials,
        )
      end

      def unlock_requirements(checker)
        if !checker.requirements_unlocked_or_can_be?
          if checker.can_update?(requirements_to_unlock: :none) then
            :none
          else
            :update_not_possible
          end
        elsif checker.can_update?(requirements_to_unlock: :own) then
          :own
        elsif checker.can_update?(requirements_to_unlock: :all) then
          :all
        else
          :update_not_possible
        end
      end

      def file_updater(updated_deps, files)
        Dependabot::FileUpdaters.for_package_manager(@settings[:pkg_manager]).new(
            dependencies: updated_deps,
            dependency_files: files,
            credentials: @credentials,
        )
      end

      def create_mr(updated_files, updated_deps, commit)
        pr_creator = Dependabot::PullRequestCreator.new(
            source: @source,
            base_commit: commit,
            dependencies: updated_deps,
            files: updated_files,
            credentials: @credentials,
            assignees: @settings[:assignees],
            author_details: @settings[:author_details] || {name: "Dependabot", email: "no-reply@github.com"},
            label_language: true,
        )

        pr_creator.create
      end
    end
  end
end
