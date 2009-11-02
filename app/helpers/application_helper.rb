# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def title(page_title)
    @content_for_title = "#{page_title} :: #{Settings.site.name}"
  end

  def active_menu(menu_name)
    @active_menu = menu_name.to_sym
  end

  def ie6update(message='Internet Explorer is missing updates required to view this site. Click here to update...')
    <<-eof
<!--[if IE 6]>
  <script type="text/javascript">
    var IE6UPDATE_OPTIONS = {
      icons_path: "http://static.ie6update.com/hosted/ie6update/images/",
      message: "#{message}"
    }
  </script>
  <script type="text/javascript" src="http://static.ie6update.com/hosted/ie6update/ie6update.js"></script>
<![endif]-->
    eof
  end

  def google_analytics_javascript(analytics_id)
    return unless Rails.env.production?
    <<-eos
      <script type="text/javascript">
      var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
      document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
      </script>
      <script type="text/javascript">
      try {
      var pageTracker = _gat._getTracker("#{analytics_id}");
      pageTracker._trackPageview();
      } catch(err) {}</script>
    eos
  end

end
