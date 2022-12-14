# frozen_string_literal: true

module Slack
  module BlockKit
    module Element
      # A select menu, just as with a standard HTML <select> tag, creates a drop
      # down menu with a list of options for a user to choose. The select menu
      # also includes type-ahead functionality, where a user can type a part or
      # all of an option string to filter the list.
      #
      # This select menu will load its options from an external data source,
      # allowing for a dynamic list of options.
      #
      # Each time a select menu of this type is opened or the user starts typing
      # in the typeahead field, we'll send a request to your specified URL. Your
      # app should return an HTTP 200 OK response, along with an
      # application/json post body with an object containing either an options
      # array, or an option_groups array.
      #
      # https://api.slack.com/reference/block-kit/block-elements#external_multi_select
      class MultiExternalSelect
        include Composition::ConfirmationDialog::Confirmable

        TYPE = 'multi_external_select'

        def initialize(
          placeholder:,
          action_id:,
          initial: nil,
          min_query_length: nil,
          emoji: nil,
          max_selected_items: nil,
          focus_on_load: nil
        )
          @placeholder = Composition::PlainText.new(text: placeholder, emoji: emoji)
          @action_id = action_id
          @initial_options = initial
          @min_query_length = min_query_length
          @max_selected_items = max_selected_items
          @focus_on_load = focus_on_load

          yield(self) if block_given?
        end

        def as_json(*)
          {
            type: TYPE,
            placeholder: @placeholder.as_json,
            action_id: @action_id,
            focus_on_load: @focus_on_load,
            initial_options: @initial_options&.map(&:as_json),
            min_query_length: @min_query_length,
            confirm: confirm&.as_json,
            max_selected_items: @max_selected_items
          }.compact
        end
      end
    end
  end
end
