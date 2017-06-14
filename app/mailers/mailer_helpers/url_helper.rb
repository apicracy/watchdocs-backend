module MailerHelpers
  module UrlHelper
    class << self
      def button_link_to(text, href)
        %(<a style="display: block; width:200px; margin: 30px auto;
                    background: #62B8F5; color: white; padding:15px;
                    text-align:center; text-transform: uppercase;
                    border-radius: 5px; text-decoration:none;"
              href="#{href}">
            #{text}
          </a>
        ).html_safe
      end

      def button_link_to_frontend(text, path)
        button_link_to(text, "#{FRONTEND_DOMAIN}/#{path}")
      end
    end
  end
end
