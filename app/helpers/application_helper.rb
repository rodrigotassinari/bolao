# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def title(page_title)
    @content_for_title = "#{page_title} :: Bolão PiTTlândia Copa 2010"
  end

  # Retorna divs para o flash especificado, com a mensagem do flash como
  # conteúdo do div e classes no div de acordo com o tipo do flash.
  #
  # Exemplo:
  #
  #   >> flash[:notice] = "Sucesso absoluto!"
  #   >> display_flashes
  #   => "<div id=\"flash-notice\">Sucesso absoluto!</div>"
  #
  def display_flashes
    return nil if flash.empty?
    #flash-error Ocorreram erros no cadastro.
    #flash-notice Alguns campos não foram preenchidos.
    #flash-success Seus dados foram cadastrados com sucesso.
    html = ''
    flash.each do |name, msg|
      next unless [:alert, :notice, :success, :error, :warning].include?(name)
      html << content_tag(:div, :id => "flash-#{name}") do
        msg
      end
    end
    html
  end
  
  def admin_signed_in?
    user_signed_in? && current_user.admin?
  end
  
  def yes_or_no(value)
    value ? 'Sim' : 'Não'
  end
  
  # Request from an iPhone or iPod touch? (Mobile Safari user agent)
  def iphone_user_agent?
    request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/]
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
  
  def uservoice_javascript(key, forum_id)
    #return unless Rails.env.production?
    <<-eos
      <script type="text/javascript">
      var uservoiceOptions = {
      key: '#{key}',
      host: '#{key}.uservoice.com', 
      forum: '#{forum_id}',
      alignment: 'left',
      background_color:'#858585', 
      text_color: 'white',
      hover_color: '#000000',
      lang: 'pt_BR',
      showTab: true
      };
      function _loadUserVoice() {
      var s = document.createElement('script');
      s.src = ("https:" == document.location.protocol ? "https://" : "http://") + "uservoice.com/javascripts/widgets/tab.js";
      document.getElementsByTagName('head')[0].appendChild(s);
      }
      _loadSuper = window.onload;
      window.onload = (typeof window.onload != 'function') ? _loadUserVoice : function() { _loadSuper(); _loadUserVoice(); };
      </script>
    eos
  end
  
end

