# http://gist.github.com/200099
#
# HaveFilter matchers for RSpec
# save as: spec/support/have_filter.rb
#
# class HomeController < ApplicationController
#   before_filter :require_user, :except => [:action_1, :action_2]
#   ...
# end
#
# describe HomeController do
#   it { should have_before_filter(:require_user).except(:action_1, :action_2) }
# end
#
# Matchers:
# have_before_filter(action)
# have_skip_before_filter(action)
# have_after_filter(action)
# have_skip_after_filter(action)
# have_around_filter(action)
# have_skip_around_filter(action)
#
# Options:
# .only(*args)
# .except(*args)

module Shoulda
  module ActionController
    module Matchers

      class HaveFilter

        def initialize(action)
          @action = action.to_sym
        end

        def matches?(subject)
          @subject = subject.class.filter_chain
          has_filter? &&
            is_skip? &&
            has_only_methods? &&
            has_except_methods?
        end

        def only(*args)
          @only_methods     = args
          @only_description = "Only: #{@only_methods.inspect}"
          @only_failure     = "for #{@only_description}"
          self
        end

        def skip
          @skip = true
          self
        end

        def except(*args)
          @except_methods     = args
          @except_description = "Except: #{@except_methods.inspect}"
          @except_failure     = "for #{@except_description}"
          self
        end

        def description
          (@skip ? "skip" : "have") +
          " #{filter_type} for #{@action.inspect}" +
          " #{@only_description}" +
          " #{@except_description}"
        end

        def failure_message
          "#{@action.inspect} is not a #{filter_type}" +
          " #{@only_failure}" +
          " #{@except_failure}"
        end

        private

        def has_filter?
          @filter = @subject.find(@action)
          @filter.is_a?(filter_class)
        end

        def is_skip?
          return true if @skip.nil?
          if filter_options.key?(:skip)
            @filter_options = @filter_options[:skip]
            return true
          else
            return false
          end
        end

        def has_only_methods?
          return true if @only_methods.nil?
          return false unless methods = filter_options[:only]
          @only_methods.each do |m|
            return false unless methods.include?(m.to_s)
          end
          return true
        end

        def has_except_methods?
          return true if @except_methods.nil?
          return false unless methods = filter_options[:except]
          @except_methods.each do |m|
            return false unless methods.include?(m.to_s)
          end
          return true
        end

        def filter_class; end

        def filter_type
          filter_class.to_s.split("::").last
        end

        def filter_options
          @filter_options ||= @filter.options
        end

      end

      def have_before_filter(action)
        HaveBeforeFilter.new(action)
      end

      def have_skip_before_filter(action)
        HaveBeforeFilter.new(action).skip
      end

      class HaveBeforeFilter < HaveFilter

        private

        def filter_class
          ::ActionController::Filters::BeforeFilter
        end
      end

      def have_after_filter(action)
        HaveAfterFilter.new(action)
      end

      def have_skip_after_filter(action)
        HaveAfterFilter.new(action).skip
      end

      class HaveAfterFilter < HaveFilter

        private

        def filter_class
          ::ActionController::Filters::AfterFilter
        end
      end

      def have_around_filter(action)
        HaveAroundFilter.new(action)
      end

      def have_skip_around_filter(action)
        HaveAroundFilter.new(action).skip
      end

      class HaveAroundFilter < HaveFilter

        private

        def filter_class
          ::ActionController::Filters::AroundFilter
        end
      end

    end
  end
end

Spec::Runner.configure do |config|
  config.include(Shoulda::ActionController::Matchers)
end
