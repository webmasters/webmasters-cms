module TestDummy
  module TableDefinitionAddRemoveForeignKey
    def remove_foreign_key(options={})
      @base.remove_foreign_key name, options
    end
    
    def foreign_key(to_table, options={})
      @base.add_foreign_key name, to_table, options
    end
  end

  module AbstractConnectionAdapterForeignKeyName
    def foreign_key_name(table_name, options) # :nodoc:
      options.fetch(:name) do
        "#{table_name}_#{options.fetch(:column)}_fk"
      end
    end
  end
end

ActiveRecord::ConnectionAdapters::Table.send :include,
  TestDummy::TableDefinitionAddRemoveForeignKey

ActiveRecord::ConnectionAdapters::AbstractAdapter.send :include,
  TestDummy::AbstractConnectionAdapterForeignKeyName
