# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

rsa = Team.create(:name => 'África do Sul',   :acronym => 'RSA', :group => 'A')
mex = Team.create(:name => 'México',          :acronym => 'MEX', :group => 'A')
uru = Team.create(:name => 'Uruguai',         :acronym => 'URU', :group => 'A')
fra = Team.create(:name => 'França',          :acronym => 'FRA', :group => 'A')
arg = Team.create(:name => 'Argentina',       :acronym => 'ARG', :group => 'B')
nga = Team.create(:name => 'Nigéria',         :acronym => 'NGA', :group => 'B')
kor = Team.create(:name => 'Coréia do Sul',   :acronym => 'KOR', :group => 'B')
gre = Team.create(:name => 'Grécia',          :acronym => 'GRE', :group => 'B')
eng = Team.create(:name => 'Inglaterra',      :acronym => 'ENG', :group => 'C')
usa = Team.create(:name => 'Estados Unidos',  :acronym => 'USA', :group => 'C')
alg = Team.create(:name => 'Algéria',         :acronym => 'ALG', :group => 'C')
svn = Team.create(:name => 'Eslovênia',       :acronym => 'SVN', :group => 'C')
ger = Team.create(:name => 'Alemanha',        :acronym => 'GER', :group => 'D')
aus = Team.create(:name => 'Austrália',       :acronym => 'AUS', :group => 'D')
srb = Team.create(:name => 'Sérvia',          :acronym => 'SRB', :group => 'D')
gha = Team.create(:name => 'Gana',            :acronym => 'GHA', :group => 'D')
ned = Team.create(:name => 'Holanda',         :acronym => 'NED', :group => 'E')
den = Team.create(:name => 'Dinamarca',       :acronym => 'DEN', :group => 'E')
jpn = Team.create(:name => 'Japão',           :acronym => 'JPN', :group => 'E')
cmr = Team.create(:name => 'Camarões',        :acronym => 'CMR', :group => 'E')
ita = Team.create(:name => 'Itália',          :acronym => 'ITA', :group => 'F')
par = Team.create(:name => 'Paraguai',        :acronym => 'PAR', :group => 'F')
nzl = Team.create(:name => 'Nova Zelândia',   :acronym => 'NZL', :group => 'F')
svk = Team.create(:name => 'Eslováquia',      :acronym => 'SVK', :group => 'F')
bra = Team.create(:name => 'Brasil',          :acronym => 'BRA', :group => 'G')
prk = Team.create(:name => 'Coréia do Norte', :acronym => 'PRK', :group => 'G')
civ = Team.create(:name => 'Costa do Marfim', :acronym => 'CIV', :group => 'G')
por = Team.create(:name => 'Portugal',        :acronym => 'POR', :group => 'G')
esp = Team.create(:name => 'Espanha',         :acronym => 'ESP', :group => 'H')
sui = Team.create(:name => 'Suíça',           :acronym => 'SUI', :group => 'H')
hon = Team.create(:name => 'Honduras',        :acronym => 'HON', :group => 'H')
chi = Team.create(:name => 'Chile',           :acronym => 'CHI', :group => 'H')

[
  [rsa, mex, "2010-06-11 11:00"],
  [uru, fra, "2010-06-11 08:30"],
  [arg, nga, "2010-06-12 11:00"],
  [kor, gre, "2010-06-12 08:30"],
  [eng, usa, "2010-06-12 15:30"],
  [alg, svn, "2010-06-13 08:30"],
  [ger, aus, "2010-06-13 15:30"],
  [srb, gha, "2010-06-13 11:00"],
  [ned, den, "2010-06-14 08:30"],
  [jpn, cmr, "2010-06-14 11:00"],
  [ita, par, "2010-06-14 15:30"],
  [nzl, svk, "2010-06-15 08:30"],
  [civ, por, "2010-06-15 11:00"],
  [bra, prk, "2010-06-15 15:30"],
  [hon, chi, "2010-06-16 08:30"],
  [esp, sui, "2010-06-16 11:00"],
  [rsa, uru, "2010-06-16 15:30"],
  [fra, mex, "2010-06-17 15:30"],
  [gre, nga, "2010-06-17 11:00"],
  [arg, kor, "2010-06-17 08:30"],
  [ger, srb, "2010-06-18 08:30"],
  [svn, usa, "2010-06-18 11:00"],
  [eng, alg, "2010-06-18 15:30"],
  [gha, aus, "2010-06-19 11:00"],
  [ned, jpn, "2010-06-19 08:30"],
  [cmr, den, "2010-06-19 15:30"],
  [svk, par, "2010-06-20 08:30"],
  [ita, nzl, "2010-06-20 11:00"],
  [bra, civ, "2010-06-20 15:30"],
  [por, prk, "2010-06-21 08:30"],
  [chi, sui, "2010-06-21 11:00"],
  [esp, hon, "2010-06-21 15:30"],
  [mex, uru, "2010-06-22 11:00"],
  [fra, rsa, "2010-06-22 11:00"],
  [nga, kor, "2010-06-22 15:30"],
  [gre, arg, "2010-06-22 15:30"],
  [svn, eng, "2010-06-23 11:00"],
  [usa, alg, "2010-06-23 11:00"],
  [gha, ger, "2010-06-23 15:30"],
  [aus, srb, "2010-06-23 15:30"],
  [svk, ita, "2010-06-24 11:00"],
  [par, nzl, "2010-06-24 11:00"],
  [den, jpn, "2010-06-24 15:30"],
  [cmr, ned, "2010-06-24 15:30"],
  [por, bra, "2010-06-25 11:00"],
  [prk, civ, "2010-06-25 11:00"],
  [chi, esp, "2010-06-25 15:30"],
  [sui, hon, "2010-06-25 15:30"]
].each do |game_data|
  Game.create(
    :stage     => 'Grupos',
    :team_a    => game_data[0],
    :team_b    => game_data[1],
    :played_at => game_data[2]
  )
end

