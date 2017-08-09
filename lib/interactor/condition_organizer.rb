# frozen_string_literal: true

module Interactor
  # Public: Interactor::ConditionOrganizer methods. Because Interactor::ConditionOrganizer is a
  # module, custom Interactor::ConditionOrganizer classes should include
  # Interactor::ConditionOrganizer rather than inherit from it.
  #
  # Examples
  #
  #   class MyOrganizer
  #     include Interactor::ConditionOrganizer
  #
  #     condition_organize InteractorOne, InteractorTwo
  #
  #     def interactor_one_condition
  #       context.key?('foo')
  #     end
  #
  #     def interactor_two_condition
  #       context.key?('bar')
  #     end
  #   end
  module ConditionOrganizer
    # Internal: Install Interactor::ConditionOrganizer's behavior in the given class.
    def self.included(base)
      base.class_eval do
        include Interactor

        extend ClassMethods
        include InstanceMethods
      end
    end

    # Internal: Interactor::ConditionOrganizer class methods.
    module ClassMethods
      # Public: Declare Interactors to be invoked as part of the
      # Interactor::ConditionOrganizer's invocation. These interactors are invoked in
      # the order in which they are declared.
      #
      # interactors - Zero or more (or an Array of) Interactor classes.
      #
      # Examples
      #
      #   class MyOrganizer
      #     include Interactor::ConditionOrganizer
      #
      #     condition_organize InteractorOne, InteractorTwo
      #
      #     def interactor_one_condition
      #       context.key?('foo')
      #     end
      #
      #     def interactor_two_condition
      #       context.key?('bar')
      #     end
      #   end
      #
      #   class MySecondOrganizer
      #     include Interactor::ConditionOrganizer
      #
      #     condition_organize [InteractorThree, InteractorFour]
      #
      #     def interactor_three_condition
      #       context.key?('foo')
      #     end
      #
      #     def interactor_four_condition
      #       context.key?('bar')
      #     end
      #   end
      #
      # Returns nothing.
      def condition_organize(*interactors)
        @condition_organized = interactors.flatten
      end

      # Internal: An Array of declared Interactors to be invoked.
      #
      # Examples
      #
      #   class MyOrganizer
      #     include Interactor::ConditionOrganizer
      #
      #     condition_organize InteractorOne, InteractorTwo
      #
      #     def interactor_one_condition
      #       context.key?('foo')
      #     end
      #
      #     def interactor_two_condition
      #       context.key?('bar')
      #     end
      #   end
      #
      #   MyOrganizer.condition_organized
      #   # => [InteractorOne, InteractorTwo]
      #
      # Returns an Array of Interactor classes or an empty Array.
      def condition_organized
        @condition_organized ||= []
      end
    end

    # Internal: Interactor::ConditionOrganizer instance methods.
    module InstanceMethods
      # Internal: Invoke the organized Interactors. An Interactor::ConditionOrganizer is
      # expected not to define its own "#call" method in favor of this default
      # implementation.
      #
      # Returns nothing.
      def call
        self.class.condition_organized.each do |interactor|
          condition_method = "#{interactor.to_s.underscore}_condition"
          interactor.call!(context) if public_send(condition_method, context)
        end
      end
    end
  end
end
