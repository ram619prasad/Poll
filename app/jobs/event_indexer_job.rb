class EventIndexerJob < ApplicationJob
  queue_as :high

  def perform(event, status)
    client = Event.__elasticsearch__
    client.index_exists? ? '' : client.create_index!
    if status.eql?('created')
      event.__elasticsearch__.index_document
    elsif status.eql?('updated')
      event.__elasticsearch__.update_document
    end
  end
end