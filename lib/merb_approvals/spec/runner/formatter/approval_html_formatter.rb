require 'rubygems'
require 'erb'
require 'spec/runner/formatter/html_formatter'

module MerbApprovals
  module RSpecFormatter
    class ApprovalHtmlFormatter < Spec::Runner::Formatter::HtmlFormatter
      def extra_failure_content(failure)
      	if failure.exception.respond_to? :received_filename
          "<iframe src='#{failure.exception.received_filename.gsub(Merb.root, ".")}' width='100%'></iframe>"
        end
      end
    end
  end
end