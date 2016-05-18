module Fastlane
  module Actions
    module SharedValues
    end

    # To share this integration with the other fastlane users:
    # - Fork https://github.com/fastlane/fastlane/tree/master/fastlane
    # - Clone the forked repository
    # - Move this integration into lib/fastlane/actions
    # - Commit, push and submit the pull request

    class SynxAction < Action
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        UI.message "Running synx on #{params[:xcodeproj]}"

        project = params[:xcodeproj]

        if not project.include? ".xcodeproj"
          project += ".xcodeproj"
        end

        command_prefix = [
          'cd',
          File.expand_path(project).shellescape,
          '&&'
        ].join(' ')

        command = [
          command_prefix,
          'synx',
          project
        ].join(' ')

        Actions.sh command

        # puts folder
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Runs Synx to tidy up your project, creating directories from your Xcode groups, and placing each file in the respective directory."
      end

      def self.available_options
        # Define all options your action supports.

        # Below a few examples
        [
          FastlaneCore::ConfigItem.new(key: :xcodeproj,
                             env_name: "FL_SYNX_PROJECT",
                             description: "optional, you must specify the path to your main Xcode project if it is not in the project root directory",
                             optional: true,
                             verify_block: proc do |value|
                               UI.user_error!("Please pass the path to the project, not the workspace") if value.end_with? ".xcworkspace"
                               UI.user_error!("Could not find Xcode project") if !File.exist?(value) and !Helper.is_test?
                             end)
        ]
      end

      def self.authors
        ["maxkramer"]
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
