# frozen_string_literal: true

# TODO: fix rubocop warning Lint/UnreachableCode
describe 'Integration' do
  def build_interactor(&block)
    interactor = Class.new.send(:include, Interactor)
    interactor.class_eval(&block) if block
    interactor
  end

  def build_organizer(options = {}, &block)
    organizer = Class.new.send(:include, Interactor::Organizer)
    organizer.organize(options[:organize]) if options[:organize]
    organizer.class_eval(&block) if block
    organizer
  end

  # rubocop:disable Style/AsciiComments
  # organizer
  #  ├─ organizer2
  #  │   ├─ interactor2a
  #  │   ├─ interactor2b
  #  │   └─ interactor2c
  #  ├─ interactor3
  #  ├─ organizer4
  #  │   ├─ interactor4a
  #  │   ├─ interactor4b
  #  │   └─ interactor4c
  #  └─ interactor5
  # rubocop:enable Style/AsciiComments

  let(:organizer) do
    build_organizer(organize: [organizer2, interactor3, organizer4, interactor5]) do
      around do |interactor|
        context.steps << :around_before
        interactor.call
        context.steps << :around_after
      end

      before do
        context.steps << :before
      end

      after do
        context.steps << :after
      end
    end
  end

  let(:organizer2) do
    build_organizer(organize: [interactor2a, interactor2b, interactor2c]) do
      around do |interactor|
        context.steps << :around_before2
        interactor.call
        context.steps << :around_after2
      end

      before do
        context.steps << :before2
      end

      after do
        context.steps << :after2
      end
    end
  end

  let(:interactor2a) do
    build_interactor do
      around do |interactor|
        context.steps << :around_before2a
        interactor.call
        context.steps << :around_after2a
      end

      before do
        context.steps << :before2a
      end

      after do
        context.steps << :after2a
      end

      def call
        context.steps << :call2a
      end

      def rollback
        context.steps << :rollback2a
      end
    end
  end

  let(:interactor2b) do
    build_interactor do
      around do |interactor|
        context.steps << :around_before2b
        interactor.call
        context.steps << :around_after2b
      end

      before do
        context.steps << :before2b
      end

      after do
        context.steps << :after2b
      end

      def call
        context.steps << :call2b
      end

      def rollback
        context.steps << :rollback2b
      end
    end
  end

  let(:interactor2c) do
    build_interactor do
      around do |interactor|
        context.steps << :around_before2c
        interactor.call
        context.steps << :around_after2c
      end

      before do
        context.steps << :before2c
      end

      after do
        context.steps << :after2c
      end

      def call
        context.steps << :call2c
      end

      def rollback
        context.steps << :rollback2c
      end
    end
  end

  let(:interactor3) do
    build_interactor do
      around do |interactor|
        context.steps << :around_before3
        interactor.call
        context.steps << :around_after3
      end

      before do
        context.steps << :before3
      end

      after do
        context.steps << :after3
      end

      def call
        context.steps << :call3
      end

      def rollback
        context.steps << :rollback3
      end
    end
  end

  let(:organizer4) do
    build_organizer(organize: [interactor4a, interactor4b, interactor4c]) do
      around do |interactor|
        context.steps << :around_before4
        interactor.call
        context.steps << :around_after4
      end

      before do
        context.steps << :before4
      end

      after do
        context.steps << :after4
      end
    end
  end

  let(:interactor4a) do
    build_interactor do
      around do |interactor|
        context.steps << :around_before4a
        interactor.call
        context.steps << :around_after4a
      end

      before do
        context.steps << :before4a
      end

      after do
        context.steps << :after4a
      end

      def call
        context.steps << :call4a
      end

      def rollback
        context.steps << :rollback4a
      end
    end
  end

  let(:interactor4b) do
    build_interactor do
      around do |interactor|
        context.steps << :around_before4b
        interactor.call
        context.steps << :around_after4b
      end

      before do
        context.steps << :before4b
      end

      after do
        context.steps << :after4b
      end

      def call
        context.steps << :call4b
      end

      def rollback
        context.steps << :rollback4b
      end
    end
  end

  let(:interactor4c) do
    build_interactor do
      around do |interactor|
        context.steps << :around_before4c
        interactor.call
        context.steps << :around_after4c
      end

      before do
        context.steps << :before4c
      end

      after do
        context.steps << :after4c
      end

      def call
        context.steps << :call4c
      end

      def rollback
        context.steps << :rollback4c
      end
    end
  end

  let(:interactor5) do
    build_interactor do
      around do |interactor|
        context.steps << :around_before5
        interactor.call
        context.steps << :around_after5
      end

      before do
        context.steps << :before5
      end

      after do
        context.steps << :after5
      end

      def call
        context.steps << :call5
      end

      def rollback
        context.steps << :rollback5
      end
    end
  end

  let(:context) { Interactor::Context.new(steps: []) }

  context 'when successful' do
    it 'calls and runs hooks in the proper sequence' do
      expect do
        organizer.call(context)
      end.to change { context.steps }.from([]).to(%i[
                                                    around_before before
                                                    around_before2 before2
                                                    around_before2a before2a call2a after2a around_after2a
                                                    around_before2b before2b call2b after2b around_after2b
                                                    around_before2c before2c call2c after2c around_after2c
                                                    after2 around_after2
                                                    around_before3 before3 call3 after3 around_after3
                                                    around_before4 before4
                                                    around_before4a before4a call4a after4a around_after4a
                                                    around_before4b before4b call4b after4b around_after4b
                                                    around_before4c before4c call4c after4c around_after4c
                                                    after4 around_after4
                                                    around_before5 before5 call5 after5 around_after5
                                                    after around_after
                                                  ])
    end
  end

  context 'when an around hook fails early' do
    let(:organizer) do
      build_organizer(organize: [organizer2, interactor3, organizer4, interactor5]) do
        around do |interactor|
          context.fail!
          context.steps << :around_before
          interactor.call
          context.steps << :around_after
        end

        before do
          context.fail!
          context.steps << :before
        end

        after do
          context.steps << :after
        end
      end
    end

    it 'aborts' do
      expect do
        organizer.call(context)
      end.not_to(change { context.steps })
    end
  end

  context 'when an around hook errors early' do
    let(:organizer) do
      build_organizer(organize: [organizer2, interactor3, organizer4, interactor5]) do
        # rubocop:disable Lint/UnreachableCode
        around do |interactor|
          raise 'foo'
          context.steps << :around_before
          interactor.call
          context.steps << :around_after
        end
        # rubocop:enable Lint/UnreachableCode

        before do
          context.fail!
          context.steps << :before
        end

        after do
          context.steps << :after
        end
      end
    end

    it 'aborts' do
      expect do
        begin
          organizer.call(context)
        rescue
          nil
        end
      end.not_to(change { context.steps })
    end

    it 'raises the error' do
      expect do
        organizer.call(context)
      end.to raise_error('foo')
    end
  end

  context 'when a before hook fails' do
    let(:organizer) do
      build_organizer(organize: [organizer2, interactor3, organizer4, interactor5]) do
        around do |interactor|
          context.steps << :around_before
          interactor.call
          context.steps << :around_after
        end

        before do
          context.fail!
          context.steps << :before
        end

        after do
          context.steps << :after
        end
      end
    end

    it 'aborts' do
      expect do
        organizer.call(context)
      end.to change { context.steps }.from([]).to([
                                                    :around_before
                                                  ])
    end
  end

  context 'when a before hook errors' do
    let(:organizer) do
      build_organizer(organize: [organizer2, interactor3, organizer4, interactor5]) do
        around do |interactor|
          context.steps << :around_before
          interactor.call
          context.steps << :around_after
        end

        # rubocop:disable Lint/UnreachableCode
        before do
          raise 'foo'
          context.steps << :before
        end
        # rubocop:enable Lint/UnreachableCode

        after do
          context.steps << :after
        end
      end
    end

    it 'aborts' do
      expect do
        begin
          organizer.call(context)
        rescue
          nil
        end
      end.to change { context.steps }.from([]).to([
                                                    :around_before
                                                  ])
    end

    it 'raises the error' do
      expect do
        organizer.call(context)
      end.to raise_error('foo')
    end
  end

  context 'when an after hook fails' do
    let(:organizer) do
      build_organizer(organize: [organizer2, interactor3, organizer4, interactor5]) do
        around do |interactor|
          context.steps << :around_before
          interactor.call
          context.steps << :around_after
        end

        before do
          context.steps << :before
        end

        after do
          context.fail!
          context.steps << :after
        end
      end
    end

    it 'rolls back successfully called interactors and the failed interactor' do
      expect do
        organizer.call(context)
      end.to change { context.steps }.from([]).to(%i[
                                                    around_before before
                                                    around_before2 before2
                                                    around_before2a before2a call2a after2a around_after2a
                                                    around_before2b before2b call2b after2b around_after2b
                                                    around_before2c before2c call2c after2c around_after2c
                                                    after2 around_after2
                                                    around_before3 before3 call3 after3 around_after3
                                                    around_before4 before4
                                                    around_before4a before4a call4a after4a around_after4a
                                                    around_before4b before4b call4b after4b around_after4b
                                                    around_before4c before4c call4c after4c around_after4c
                                                    after4 around_after4
                                                    around_before5 before5 call5 after5 around_after5
                                                    rollback5
                                                    rollback4c
                                                    rollback4b
                                                    rollback4a
                                                    rollback3
                                                    rollback2c
                                                    rollback2b
                                                    rollback2a
                                                  ])
    end
  end

  context 'when an after hook errors' do
    let(:organizer) do
      build_organizer(organize: [organizer2, interactor3, organizer4, interactor5]) do
        around do |interactor|
          context.steps << :around_before
          interactor.call
          context.steps << :around_after
        end

        before do
          context.steps << :before
        end

        # rubocop:disable Lint/UnreachableCode
        after do
          raise 'foo'
          context.steps << :after
        end
        # rubocop:enable Lint/UnreachableCode
      end
    end

    it 'rolls back successfully called interactors and the failed interactor' do
      expect do
        begin
          organizer.call(context)
        rescue
          nil
        end
      end.to change { context.steps }.from([]).to(%i[
                                                    around_before before
                                                    around_before2 before2
                                                    around_before2a before2a call2a after2a around_after2a
                                                    around_before2b before2b call2b after2b around_after2b
                                                    around_before2c before2c call2c after2c around_after2c
                                                    after2 around_after2
                                                    around_before3 before3 call3 after3 around_after3
                                                    around_before4 before4
                                                    around_before4a before4a call4a after4a around_after4a
                                                    around_before4b before4b call4b after4b around_after4b
                                                    around_before4c before4c call4c after4c around_after4c
                                                    after4 around_after4
                                                    around_before5 before5 call5 after5 around_after5
                                                    rollback5
                                                    rollback4c
                                                    rollback4b
                                                    rollback4a
                                                    rollback3
                                                    rollback2c
                                                    rollback2b
                                                    rollback2a
                                                  ])
    end

    it 'raises the error' do
      expect do
        organizer.call(context)
      end.to raise_error('foo')
    end
  end

  context 'when an around hook fails late' do
    let(:organizer) do
      build_organizer(organize: [organizer2, interactor3, organizer4, interactor5]) do
        around do |interactor|
          context.steps << :around_before
          interactor.call
          context.fail!
          context.steps << :around_after
        end

        before do
          context.steps << :before
        end

        after do
          context.steps << :after
        end
      end
    end

    it 'rolls back successfully called interactors and the failed interactor' do
      expect do
        organizer.call(context)
      end.to change { context.steps }.from([]).to(%i[
                                                    around_before before
                                                    around_before2 before2
                                                    around_before2a before2a call2a after2a around_after2a
                                                    around_before2b before2b call2b after2b around_after2b
                                                    around_before2c before2c call2c after2c around_after2c
                                                    after2 around_after2
                                                    around_before3 before3 call3 after3 around_after3
                                                    around_before4 before4
                                                    around_before4a before4a call4a after4a around_after4a
                                                    around_before4b before4b call4b after4b around_after4b
                                                    around_before4c before4c call4c after4c around_after4c
                                                    after4 around_after4
                                                    around_before5 before5 call5 after5 around_after5
                                                    after
                                                    rollback5
                                                    rollback4c
                                                    rollback4b
                                                    rollback4a
                                                    rollback3
                                                    rollback2c
                                                    rollback2b
                                                    rollback2a
                                                  ])
    end
  end

  context 'when an around hook errors late' do
    let(:organizer) do
      build_organizer(organize: [organizer2, interactor3, organizer4, interactor5]) do
        # rubocop:disable Lint/UnreachableCode
        around do |interactor|
          context.steps << :around_before
          interactor.call
          raise 'foo'
          context.steps << :around_after
        end
        # rubocop:enable Lint/UnreachableCode

        before do
          context.steps << :before
        end

        after do
          context.steps << :after
        end
      end
    end

    it 'rolls back successfully called interactors and the failed interactor' do
      expect do
        begin
          organizer.call(context)
        rescue
          nil
        end
      end.to change { context.steps }.from([]).to(%i[
                                                    around_before before
                                                    around_before2 before2
                                                    around_before2a before2a call2a after2a around_after2a
                                                    around_before2b before2b call2b after2b around_after2b
                                                    around_before2c before2c call2c after2c around_after2c
                                                    after2 around_after2
                                                    around_before3 before3 call3 after3 around_after3
                                                    around_before4 before4
                                                    around_before4a before4a call4a after4a around_after4a
                                                    around_before4b before4b call4b after4b around_after4b
                                                    around_before4c before4c call4c after4c around_after4c
                                                    after4 around_after4
                                                    around_before5 before5 call5 after5 around_after5
                                                    after
                                                    rollback5
                                                    rollback4c
                                                    rollback4b
                                                    rollback4a
                                                    rollback3
                                                    rollback2c
                                                    rollback2b
                                                    rollback2a
                                                  ])
    end

    it 'raises the error' do
      expect do
        organizer.call(context)
      end.to raise_error('foo')
    end
  end

  context 'when a nested around hook fails early' do
    let(:interactor3) do
      build_interactor do
        around do |interactor|
          context.fail!
          context.steps << :around_before3
          interactor.call
          context.steps << :around_after3
        end

        before do
          context.steps << :before3
        end

        after do
          context.steps << :after3
        end

        def call
          context.steps << :call3
        end

        def rollback
          context.steps << :rollback3
        end
      end
    end

    it 'rolls back successfully called interactors' do
      expect do
        organizer.call(context)
      end.to change { context.steps }.from([]).to(%i[
                                                    around_before before
                                                    around_before2 before2
                                                    around_before2a before2a call2a after2a around_after2a
                                                    around_before2b before2b call2b after2b around_after2b
                                                    around_before2c before2c call2c after2c around_after2c
                                                    after2 around_after2
                                                    rollback2c
                                                    rollback2b
                                                    rollback2a
                                                  ])
    end
  end

  context 'when a nested around hook errors early' do
    let(:interactor3) do
      build_interactor do
        # rubocop:disable Lint/UnreachableCode
        around do |interactor|
          raise 'foo'
          context.steps << :around_before3
          interactor.call
          context.steps << :around_after3
        end
        # rubocop:enable Lint/UnreachableCode

        before do
          context.steps << :before3
        end

        after do
          context.steps << :after3
        end

        def call
          context.steps << :call3
        end

        def rollback
          context.steps << :rollback3
        end
      end
    end

    it 'rolls back successfully called interactors' do
      expect do
        begin
          organizer.call(context)
        rescue
          nil
        end
      end.to change { context.steps }.from([]).to(%i[
                                                    around_before before
                                                    around_before2 before2
                                                    around_before2a before2a call2a after2a around_after2a
                                                    around_before2b before2b call2b after2b around_after2b
                                                    around_before2c before2c call2c after2c around_after2c
                                                    after2 around_after2
                                                    rollback2c
                                                    rollback2b
                                                    rollback2a
                                                  ])
    end

    it 'raises the error' do
      expect do
        organizer.call(context)
      end.to raise_error('foo')
    end
  end

  context 'when a nested before hook fails' do
    let(:interactor3) do
      build_interactor do
        around do |interactor|
          context.steps << :around_before3
          interactor.call
          context.steps << :around_after3
        end

        before do
          context.fail!
          context.steps << :before3
        end

        after do
          context.steps << :after3
        end

        def call
          context.steps << :call3
        end

        def rollback
          context.steps << :rollback3
        end
      end
    end

    it 'rolls back successfully called interactors' do
      expect do
        organizer.call(context)
      end.to change { context.steps }.from([]).to(%i[
                                                    around_before before
                                                    around_before2 before2
                                                    around_before2a before2a call2a after2a around_after2a
                                                    around_before2b before2b call2b after2b around_after2b
                                                    around_before2c before2c call2c after2c around_after2c
                                                    after2 around_after2
                                                    around_before3
                                                    rollback2c
                                                    rollback2b
                                                    rollback2a
                                                  ])
    end
  end

  context 'when a nested before hook errors' do
    let(:interactor3) do
      build_interactor do
        around do |interactor|
          context.steps << :around_before3
          interactor.call
          context.steps << :around_after3
        end

        # rubocop:disable Lint/UnreachableCode
        before do
          raise 'foo'
          context.steps << :before3
        end
        # rubocop:enable Lint/UnreachableCode

        after do
          context.steps << :after3
        end

        def call
          context.steps << :call3
        end

        def rollback
          context.steps << :rollback3
        end
      end
    end

    it 'rolls back successfully called interactors' do
      expect do
        begin
          organizer.call(context)
        rescue
          nil
        end
      end.to change { context.steps }.from([]).to(%i[
                                                    around_before before
                                                    around_before2 before2
                                                    around_before2a before2a call2a after2a around_after2a
                                                    around_before2b before2b call2b after2b around_after2b
                                                    around_before2c before2c call2c after2c around_after2c
                                                    after2 around_after2
                                                    around_before3
                                                    rollback2c
                                                    rollback2b
                                                    rollback2a
                                                  ])
    end

    it 'raises the error' do
      expect do
        organizer.call(context)
      end.to raise_error('foo')
    end
  end

  context 'when a nested call fails' do
    let(:interactor3) do
      build_interactor do
        around do |interactor|
          context.steps << :around_before3
          interactor.call
          context.steps << :around_after3
        end

        before do
          context.steps << :before3
        end

        after do
          context.steps << :after3
        end

        def call
          context.fail!
          context.steps << :call3
        end

        def rollback
          context.steps << :rollback3
        end
      end
    end

    it 'rolls back successfully called interactors' do
      expect do
        organizer.call(context)
      end.to change { context.steps }.from([]).to(%i[
                                                    around_before before
                                                    around_before2 before2
                                                    around_before2a before2a call2a after2a around_after2a
                                                    around_before2b before2b call2b after2b around_after2b
                                                    around_before2c before2c call2c after2c around_after2c
                                                    after2 around_after2
                                                    around_before3 before3
                                                    rollback2c
                                                    rollback2b
                                                    rollback2a
                                                  ])
    end
  end

  context 'when a nested call errors' do
    let(:interactor3) do
      build_interactor do
        around do |interactor|
          context.steps << :around_before3
          interactor.call
          context.steps << :around_after3
        end

        before do
          context.steps << :before3
        end

        after do
          context.steps << :after3
        end

        # rubocop:disable Lint/UnreachableCode
        def call
          raise 'foo'
          context.steps << :call3
        end
        # rubocop:enable Lint/UnreachableCode

        def rollback
          context.steps << :rollback3
        end
      end
    end

    it 'rolls back successfully called interactors' do
      expect do
        begin
          organizer.call(context)
        rescue
          nil
        end
      end.to change { context.steps }.from([]).to(%i[
                                                    around_before before
                                                    around_before2 before2
                                                    around_before2a before2a call2a after2a around_after2a
                                                    around_before2b before2b call2b after2b around_after2b
                                                    around_before2c before2c call2c after2c around_after2c
                                                    after2 around_after2
                                                    around_before3 before3
                                                    rollback2c
                                                    rollback2b
                                                    rollback2a
                                                  ])
    end

    it 'raises the error' do
      expect do
        organizer.call(context)
      end.to raise_error('foo')
    end
  end

  context 'when a nested after hook fails' do
    let(:interactor3) do
      build_interactor do
        around do |interactor|
          context.steps << :around_before3
          interactor.call
          context.steps << :around_after3
        end

        before do
          context.steps << :before3
        end

        after do
          context.fail!
          context.steps << :after3
        end

        def call
          context.steps << :call3
        end

        def rollback
          context.steps << :rollback3
        end
      end
    end

    it 'rolls back successfully called interactors and the failed interactor' do
      expect do
        organizer.call(context)
      end.to change { context.steps }.from([]).to(%i[
                                                    around_before before
                                                    around_before2 before2
                                                    around_before2a before2a call2a after2a around_after2a
                                                    around_before2b before2b call2b after2b around_after2b
                                                    around_before2c before2c call2c after2c around_after2c
                                                    after2 around_after2
                                                    around_before3 before3 call3
                                                    rollback3
                                                    rollback2c
                                                    rollback2b
                                                    rollback2a
                                                  ])
    end
  end

  context 'when a nested after hook errors' do
    let(:interactor3) do
      build_interactor do
        around do |interactor|
          context.steps << :around_before3
          interactor.call
          context.steps << :around_after3
        end

        before do
          context.steps << :before3
        end

        # rubocop:disable Lint/UnreachableCode
        after do
          raise 'foo'
          context.steps << :after3
        end
        # rubocop:enable Lint/UnreachableCode

        def call
          context.steps << :call3
        end

        def rollback
          context.steps << :rollback3
        end
      end
    end

    it 'rolls back successfully called interactors and the failed interactor' do
      expect do
        begin
          organizer.call(context)
        rescue
          nil
        end
      end.to change { context.steps }.from([]).to(%i[
                                                    around_before before
                                                    around_before2 before2
                                                    around_before2a before2a call2a after2a around_after2a
                                                    around_before2b before2b call2b after2b around_after2b
                                                    around_before2c before2c call2c after2c around_after2c
                                                    after2 around_after2
                                                    around_before3 before3 call3
                                                    rollback3
                                                    rollback2c
                                                    rollback2b
                                                    rollback2a
                                                  ])
    end

    it 'raises the error' do
      expect do
        organizer.call(context)
      end.to raise_error('foo')
    end
  end

  context 'when a nested around hook fails late' do
    let(:interactor3) do
      build_interactor do
        around do |interactor|
          context.steps << :around_before3
          interactor.call
          context.fail!
          context.steps << :around_after3
        end

        before do
          context.steps << :before3
        end

        after do
          context.steps << :after3
        end

        def call
          context.steps << :call3
        end

        def rollback
          context.steps << :rollback3
        end
      end
    end

    it 'rolls back successfully called interactors and the failed interactor' do
      expect do
        organizer.call(context)
      end.to change { context.steps }.from([]).to(%i[
                                                    around_before before
                                                    around_before2 before2
                                                    around_before2a before2a call2a after2a around_after2a
                                                    around_before2b before2b call2b after2b around_after2b
                                                    around_before2c before2c call2c after2c around_after2c
                                                    after2 around_after2
                                                    around_before3 before3 call3 after3
                                                    rollback3
                                                    rollback2c
                                                    rollback2b
                                                    rollback2a
                                                  ])
    end
  end

  context 'when a nested around hook errors late' do
    let(:interactor3) do
      build_interactor do
        # rubocop:disable Lint/UnreachableCode
        around do |interactor|
          context.steps << :around_before3
          interactor.call
          raise 'foo'
          context.steps << :around_after3
        end
        # rubocop:enable Lint/UnreachableCode

        before do
          context.steps << :before3
        end

        after do
          context.steps << :after3
        end

        def call
          context.steps << :call3
        end

        def rollback
          context.steps << :rollback3
        end
      end
    end

    it 'rolls back successfully called interactors and the failed interactor' do
      expect do
        begin
          organizer.call(context)
        rescue
          nil
        end
      end.to change { context.steps }.from([]).to(%i[
                                                    around_before before
                                                    around_before2 before2
                                                    around_before2a before2a call2a after2a around_after2a
                                                    around_before2b before2b call2b after2b around_after2b
                                                    around_before2c before2c call2c after2c around_after2c
                                                    after2 around_after2
                                                    around_before3 before3 call3 after3
                                                    rollback3
                                                    rollback2c
                                                    rollback2b
                                                    rollback2a
                                                  ])
    end

    it 'raises the error' do
      expect do
        organizer.call(context)
      end.to raise_error('foo')
    end
  end

  context 'when a deeply nested around hook fails early' do
    let(:interactor4b) do
      build_interactor do
        around do |interactor|
          context.fail!
          context.steps << :around_before4b
          interactor.call
          context.steps << :around_after4b
        end

        before do
          context.steps << :before4b
        end

        after do
          context.steps << :after4b
        end

        def call
          context.steps << :call4b
        end

        def rollback
          context.steps << :rollback4b
        end
      end
    end

    it 'rolls back successfully called interactors' do
      expect do
        organizer.call(context)
      end.to change { context.steps }.from([]).to(%i[
                                                    around_before before
                                                    around_before2 before2
                                                    around_before2a before2a call2a after2a around_after2a
                                                    around_before2b before2b call2b after2b around_after2b
                                                    around_before2c before2c call2c after2c around_after2c
                                                    after2 around_after2
                                                    around_before3 before3 call3 after3 around_after3
                                                    around_before4 before4
                                                    around_before4a before4a call4a after4a around_after4a
                                                    rollback4a
                                                    rollback3
                                                    rollback2c
                                                    rollback2b
                                                    rollback2a
                                                  ])
    end
  end

  context 'when a deeply nested around hook errors early' do
    let(:interactor4b) do
      build_interactor do
        # rubocop:disable Lint/UnreachableCode
        around do |interactor|
          raise 'foo'
          context.steps << :around_before4b
          interactor.call
          context.steps << :around_after4b
        end
        # rubocop:enable Lint/UnreachableCode

        before do
          context.steps << :before4b
        end

        after do
          context.steps << :after4b
        end

        def call
          context.steps << :call4b
        end

        def rollback
          context.steps << :rollback4b
        end
      end
    end

    it 'rolls back successfully called interactors' do
      expect do
        begin
          organizer.call(context)
        rescue
          nil
        end
      end.to change { context.steps }.from([]).to(%i[
                                                    around_before before
                                                    around_before2 before2
                                                    around_before2a before2a call2a after2a around_after2a
                                                    around_before2b before2b call2b after2b around_after2b
                                                    around_before2c before2c call2c after2c around_after2c
                                                    after2 around_after2
                                                    around_before3 before3 call3 after3 around_after3
                                                    around_before4 before4
                                                    around_before4a before4a call4a after4a around_after4a
                                                    rollback4a
                                                    rollback3
                                                    rollback2c
                                                    rollback2b
                                                    rollback2a
                                                  ])
    end

    it 'raises the error' do
      expect do
        organizer.call(context)
      end.to raise_error('foo')
    end
  end

  context 'when a deeply nested before hook fails' do
    let(:interactor4b) do
      build_interactor do
        around do |interactor|
          context.steps << :around_before4b
          interactor.call
          context.steps << :around_after4b
        end

        before do
          context.fail!
          context.steps << :before4b
        end

        after do
          context.steps << :after4b
        end

        def call
          context.steps << :call4b
        end

        def rollback
          context.steps << :rollback4b
        end
      end
    end

    it 'rolls back successfully called interactors' do
      expect do
        organizer.call(context)
      end.to change { context.steps }.from([]).to(%i[
                                                    around_before before
                                                    around_before2 before2
                                                    around_before2a before2a call2a after2a around_after2a
                                                    around_before2b before2b call2b after2b around_after2b
                                                    around_before2c before2c call2c after2c around_after2c
                                                    after2 around_after2
                                                    around_before3 before3 call3 after3 around_after3
                                                    around_before4 before4
                                                    around_before4a before4a call4a after4a around_after4a
                                                    around_before4b
                                                    rollback4a
                                                    rollback3
                                                    rollback2c
                                                    rollback2b
                                                    rollback2a
                                                  ])
    end
  end

  context 'when a deeply nested before hook errors' do
    let(:interactor4b) do
      build_interactor do
        around do |interactor|
          context.steps << :around_before4b
          interactor.call
          context.steps << :around_after4b
        end

        # rubocop:disable Lint/UnreachableCode
        before do
          raise 'foo'
          context.steps << :before4b
        end
        # rubocop:enable Lint/UnreachableCode

        after do
          context.steps << :after4b
        end

        def call
          context.steps << :call4b
        end

        def rollback
          context.steps << :rollback4b
        end
      end
    end

    it 'rolls back successfully called interactors' do
      expect do
        begin
          organizer.call(context)
        rescue
          nil
        end
      end.to change { context.steps }.from([]).to(%i[
                                                    around_before before
                                                    around_before2 before2
                                                    around_before2a before2a call2a after2a around_after2a
                                                    around_before2b before2b call2b after2b around_after2b
                                                    around_before2c before2c call2c after2c around_after2c
                                                    after2 around_after2
                                                    around_before3 before3 call3 after3 around_after3
                                                    around_before4 before4
                                                    around_before4a before4a call4a after4a around_after4a
                                                    around_before4b
                                                    rollback4a
                                                    rollback3
                                                    rollback2c
                                                    rollback2b
                                                    rollback2a
                                                  ])
    end

    it 'raises the error' do
      expect do
        organizer.call(context)
      end.to raise_error('foo')
    end
  end

  context 'when a deeply nested call fails' do
    let(:interactor4b) do
      build_interactor do
        around do |interactor|
          context.steps << :around_before4b
          interactor.call
          context.steps << :around_after4b
        end

        before do
          context.steps << :before4b
        end

        after do
          context.steps << :after4b
        end

        def call
          context.fail!
          context.steps << :call4b
        end

        def rollback
          context.steps << :rollback4b
        end
      end
    end

    it 'rolls back successfully called interactors' do
      expect do
        organizer.call(context)
      end.to change { context.steps }.from([]).to(%i[
                                                    around_before before
                                                    around_before2 before2
                                                    around_before2a before2a call2a after2a around_after2a
                                                    around_before2b before2b call2b after2b around_after2b
                                                    around_before2c before2c call2c after2c around_after2c
                                                    after2 around_after2
                                                    around_before3 before3 call3 after3 around_after3
                                                    around_before4 before4
                                                    around_before4a before4a call4a after4a around_after4a
                                                    around_before4b before4b
                                                    rollback4a
                                                    rollback3
                                                    rollback2c
                                                    rollback2b
                                                    rollback2a
                                                  ])
    end
  end

  context 'when a deeply nested call errors' do
    let(:interactor4b) do
      build_interactor do
        around do |interactor|
          context.steps << :around_before4b
          interactor.call
          context.steps << :around_after4b
        end

        before do
          context.steps << :before4b
        end

        after do
          context.steps << :after4b
        end

        # rubocop:disable Lint/UnreachableCode
        def call
          raise 'foo'
          context.steps << :call4b
        end
        # rubocop:enable Lint/UnreachableCode

        def rollback
          context.steps << :rollback4b
        end
      end
    end

    it 'rolls back successfully called interactors' do
      expect do
        begin
          organizer.call(context)
        rescue
          nil
        end
      end.to change { context.steps }.from([]).to(%i[
                                                    around_before before
                                                    around_before2 before2
                                                    around_before2a before2a call2a after2a around_after2a
                                                    around_before2b before2b call2b after2b around_after2b
                                                    around_before2c before2c call2c after2c around_after2c
                                                    after2 around_after2
                                                    around_before3 before3 call3 after3 around_after3
                                                    around_before4 before4
                                                    around_before4a before4a call4a after4a around_after4a
                                                    around_before4b before4b
                                                    rollback4a
                                                    rollback3
                                                    rollback2c
                                                    rollback2b
                                                    rollback2a
                                                  ])
    end

    it 'raises the error' do
      expect do
        organizer.call(context)
      end.to raise_error('foo')
    end
  end

  context 'when a deeply nested after hook fails' do
    let(:interactor4b) do
      build_interactor do
        around do |interactor|
          context.steps << :around_before4b
          interactor.call
          context.steps << :around_after4b
        end

        before do
          context.steps << :before4b
        end

        after do
          context.fail!
          context.steps << :after4b
        end

        def call
          context.steps << :call4b
        end

        def rollback
          context.steps << :rollback4b
        end
      end
    end

    it 'rolls back successfully called interactors and the failed interactor' do
      expect do
        organizer.call(context)
      end.to change { context.steps }.from([]).to(%i[
                                                    around_before before
                                                    around_before2 before2
                                                    around_before2a before2a call2a after2a around_after2a
                                                    around_before2b before2b call2b after2b around_after2b
                                                    around_before2c before2c call2c after2c around_after2c
                                                    after2 around_after2
                                                    around_before3 before3 call3 after3 around_after3
                                                    around_before4 before4
                                                    around_before4a before4a call4a after4a around_after4a
                                                    around_before4b before4b call4b
                                                    rollback4b
                                                    rollback4a
                                                    rollback3
                                                    rollback2c
                                                    rollback2b
                                                    rollback2a
                                                  ])
    end
  end

  context 'when a deeply nested after hook errors' do
    let(:interactor4b) do
      build_interactor do
        around do |interactor|
          context.steps << :around_before4b
          interactor.call
          context.steps << :around_after4b
        end

        before do
          context.steps << :before4b
        end

        # rubocop:disable Lint/UnreachableCode
        after do
          raise 'foo'
          context.steps << :after4b
        end
        # rubocop:enable Lint/UnreachableCode

        def call
          context.steps << :call4b
        end

        def rollback
          context.steps << :rollback4b
        end
      end
    end

    it 'rolls back successfully called interactors and the failed interactor' do
      expect do
        begin
          organizer.call(context)
        rescue
          nil
        end
      end.to change { context.steps }.from([]).to(%i[
                                                    around_before before
                                                    around_before2 before2
                                                    around_before2a before2a call2a after2a around_after2a
                                                    around_before2b before2b call2b after2b around_after2b
                                                    around_before2c before2c call2c after2c around_after2c
                                                    after2 around_after2
                                                    around_before3 before3 call3 after3 around_after3
                                                    around_before4 before4
                                                    around_before4a before4a call4a after4a around_after4a
                                                    around_before4b before4b call4b
                                                    rollback4b
                                                    rollback4a
                                                    rollback3
                                                    rollback2c
                                                    rollback2b
                                                    rollback2a
                                                  ])
    end

    it 'raises the error' do
      expect do
        organizer.call(context)
      end.to raise_error('foo')
    end
  end

  context 'when a deeply nested around hook fails late' do
    let(:interactor4b) do
      build_interactor do
        around do |interactor|
          context.steps << :around_before4b
          interactor.call
          context.fail!
          context.steps << :around_after4b
        end

        before do
          context.steps << :before4b
        end

        after do
          context.steps << :after4b
        end

        def call
          context.steps << :call4b
        end

        def rollback
          context.steps << :rollback4b
        end
      end
    end

    it 'rolls back successfully called interactors and the failed interactor' do
      expect do
        organizer.call(context)
      end.to change { context.steps }.from([]).to(%i[
                                                    around_before before
                                                    around_before2 before2
                                                    around_before2a before2a call2a after2a around_after2a
                                                    around_before2b before2b call2b after2b around_after2b
                                                    around_before2c before2c call2c after2c around_after2c
                                                    after2 around_after2
                                                    around_before3 before3 call3 after3 around_after3
                                                    around_before4 before4
                                                    around_before4a before4a call4a after4a around_after4a
                                                    around_before4b before4b call4b after4b
                                                    rollback4b
                                                    rollback4a
                                                    rollback3
                                                    rollback2c
                                                    rollback2b
                                                    rollback2a
                                                  ])
    end
  end

  context 'when a deeply nested around hook errors late' do
    let(:interactor4b) do
      build_interactor do
        # rubocop:disable Lint/UnreachableCode
        around do |interactor|
          context.steps << :around_before4b
          interactor.call
          raise 'foo'
          context.steps << :around_after4b
        end
        # rubocop:enable Lint/UnreachableCode

        before do
          context.steps << :before4b
        end

        after do
          context.steps << :after4b
        end

        def call
          context.steps << :call4b
        end

        def rollback
          context.steps << :rollback4b
        end
      end
    end

    it 'rolls back successfully called interactors and the failed interactor' do
      expect do
        begin
          organizer.call(context)
        rescue
          nil
        end
      end.to change { context.steps }.from([]).to(%i[
                                                    around_before before
                                                    around_before2 before2
                                                    around_before2a before2a call2a after2a around_after2a
                                                    around_before2b before2b call2b after2b around_after2b
                                                    around_before2c before2c call2c after2c around_after2c
                                                    after2 around_after2
                                                    around_before3 before3 call3 after3 around_after3
                                                    around_before4 before4
                                                    around_before4a before4a call4a after4a around_after4a
                                                    around_before4b before4b call4b after4b
                                                    rollback4b
                                                    rollback4a
                                                    rollback3
                                                    rollback2c
                                                    rollback2b
                                                    rollback2a
                                                  ])
    end

    it 'raises the error' do
      expect do
        organizer.call(context)
      end.to raise_error('foo')
    end
  end
end
