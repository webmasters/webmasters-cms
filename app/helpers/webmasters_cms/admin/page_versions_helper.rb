module WebmastersCms
  module Admin
    module PageVersionsHelper
      def page_versions_in_array
        array = []
        collection_without_current_version.collect do |r|
           array << [ r.version.to_s, r.version ]
        end
        array
      end
    end
  end
end
