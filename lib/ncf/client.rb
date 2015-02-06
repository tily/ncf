require 'ace-client'

module Ncf
	class Client < AceClient::Query2
		class ResponseError < StandardError; end

		def initialize(options)
			super(options)
		end

		def execute_stack(json)
			@response = self.action('ExecuteStack', 'TemplateBody' => json)
			raise_if_response_error
			@response
		end

		def describe_stack(exec_id)
			@response = self.action('DescribeStack', 'ExecutionId' => exec_id)
			raise_if_response_error
			@response
		end

		def raise_if_response_error
			if @response.code != 200
				code = @response['ErrorResponse']['Error']['Code']
				message = @response['ErrorResponse']['Error']['Message']
				raise ResponseError, "#{code}: #{message}"
			end
		end
	end
end
