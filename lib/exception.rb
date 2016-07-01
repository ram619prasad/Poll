module Poll
	module Exception
	  class AccessDeniedError < StandardError; end

	  class NotAuthenticatedError < StandardError; end

	  class AuthenticationTimeoutError < StandardError; end

	  class NoApiKeyError < StandardError; end

	  class InvalidParameter < StandardError; end

	  class AlreadyAttending < StandardError; end

	  class AlreadyInterested < StandardError; end

	  class Scheduled < StandardError; end

	  class Expired < StandardError; end
	end
end
