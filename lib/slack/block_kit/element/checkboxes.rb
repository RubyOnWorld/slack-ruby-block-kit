# frozen_string_literal: true

module Slack
  module BlockKit
    module Element
      # A checkbox group that allows a user to choose multiple items from
      # a list of possible options.
      #
      # https://api.slack.com/reference/messaging/block-elements#checkboxes
      class Checkboxes
        include Composition::ConfirmationDialog::Confirmable

        TYPE = 'checkboxes'

        def initialize(action_id:)
          @action_id = action_id
          @options = []
          @initial_options = []

          yield(self) if block_given?
        end

        def option(value:, text:, description: nil)
          @options << Composition::Option.new(
            value: value,
            text: text,
            description: description
          )

          self
        end

        def initial(value:, text:, description: nil)
          @initial_options << Composition::Option.new(
            value: value,
            text: text,
            description: description
          )

          self
        end

        def as_json(*)
          {
            type: TYPE,
            action_id: @action_id,
            options: @options.map(&:as_json),
            initial_options: @initial_options.any? ? @initial_options.map(&:as_json) : nil,
            confirm: confirm&.as_json
          }.compact
        end
      end
    end
  end
end
