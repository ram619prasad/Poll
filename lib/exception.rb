module Poll
	module Exception
	  class AccessDeniedError < StandardError; end

	  class NotAuthenticatedError < StandardError; end

	  class AuthenticationTimeoutError < StandardError; end

	  class NoApiKeyError < StandardError; end
	end
end
