// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function submit_bet(field) {
  element = $(field).parents("form");
  goals_a = element.find("input#bet_goals_a").val();
  goals_b = element.find("input#bet_goals_b").val();
  if (goals_a != "" && goals_b != "") {
    element.find('img.spinner').show();
    $.post(element.attr("action"), $(element).serialize(), null, "script");
    return false;
  }
}

function submit_penalty_bet(field) {
  element = $(field).parents("form");
  goals_a = element.find("input#bet_goals_a").val();
  goals_b = element.find("input#bet_goals_b").val();
  penalty_goals_a = element.find("input#bet_penalty_goals_a").val();
  penalty_goals_b = element.find("input#bet_penalty_goals_b").val();
  if (goals_a != "" && goals_b != "" && penalty_goals_a != "" && penalty_goals_b != "") {
    element.find('img.spinner').show();
    $.post(element.attr("action"), $(element).serialize(), null, "script");
    return false;
  }
}

function submit_bonus_bet(field) {
  element = $(field).parents("form");
  answer = element.find("input#bonus_bet_answer").val();
  if (answer != "") {
    element.find('img.spinner').show();
    $.post(element.attr("action"), $(element).serialize(), null, "script");
    return false;
  }
}
