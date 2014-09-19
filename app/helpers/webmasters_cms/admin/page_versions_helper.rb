module WebmastersCms
  module Admin
    module PageVersionsHelper
      def page_versions_for_select
        collection_without_current_version.collect do |r|
          [ r.version.to_s, r.version ]
        end
      end
    end
  end
end
