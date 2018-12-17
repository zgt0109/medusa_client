class ApplicationController < ActionController::Base
    def render_json(**options)
        render(json: {code: options[:code] || "-1", message: options[:message] || "ERROR"}, status: options[:status])and return
    end
end
