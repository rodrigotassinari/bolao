# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

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
  
end

