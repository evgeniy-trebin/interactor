# frozen_string_literal: true

module Interactor
  describe ConditionOrganizer do
    include_examples :lint

    let(:organizer) { Class.new.send(:include, ConditionOrganizer) }

    describe '.condition_organize' do
      let(:interactor2) { double(:interactor2) }
      let(:interactor3) { double(:interactor3) }

      it 'sets interactors given class arguments' do
        expect do
          organizer.condition_organize(interactor2, interactor3)
        end.to change { organizer.condition_organized }.from([]).to([interactor2, interactor3])
      end

      it 'sets interactors given an array of classes' do
        expect do
          organizer.condition_organize([interactor2, interactor3])
        end.to change { organizer.condition_organized }.from([]).to([interactor2, interactor3])
      end
    end

    describe '.organized' do
      it 'is empty by default' do
        expect(organizer.condition_organized).to eq([])
      end
    end

    describe '#call' do
      let(:instance) { organizer.new }
      let(:context) { double(:context, foo: true, bar: false) }
      let(:interactor2) { double(:interactor2) }
      let(:interactor3) { double(:interactor3) }

      before do
        allow(interactor2).to receive(:to_s).and_return('Interactor2')
        allow(interactor3).to receive(:to_s).and_return('Interactor3')
        allow(instance).to receive(:context) { context }
        allow(organizer).to receive(:condition_organized) {
          [interactor2, interactor3]
        }
      end

      subject { instance.call }

      context 'when all conditions are exist' do
        before do
          instance.instance_eval do
            def interactor2_condition(context)
              context.foo
            end

            def interactor3_condition(context)
              context.bar
            end
          end
        end

        it 'calls interactor2 and does not call interactor3' do
          expect(interactor2).to receive(:call!).once.with(context).ordered
          expect(interactor3).not_to receive(:call!)
          subject
        end
      end

      context 'when some condition is missing' do
        before do
          instance.instance_eval do
            def interactor2_condition(context)
              context.foo
            end
          end
        end

        it 'calls interactor2 and raises NoMethodError for interactor3 condition' do
          expect(interactor2).to receive(:call!).once.with(context).ordered
          expect { subject }.to raise_error(NoMethodError)
        end
      end
    end
  end
end
