$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "sequel/through"
require "minitest/autorun"

class << Sequel::Model
  attr_writer :db_schema
  alias orig_columns columns
  def columns(*cols)
    return super if cols.empty?
    define_method(:columns){cols}
    @dataset.send(:columns=, cols) if @dataset
    def_column_accessor(*cols)
    @columns = cols
    @db_schema = {}
    cols.each{|c| @db_schema[c] = {}}
  end
end

Sequel::DB = nil
Sequel::Model.use_transactions = false
Sequel::Model.cache_anonymous_models = false

db = Sequel.mock(:fetch=>{:id => 1, :x => 1}, :numrows=>1, :autoid=>proc{|sql| 10})
def db.schema(*) [[:id, {:primary_key=>true}]] end
def db.reset() sqls end
def db.supports_schema_parsing?() true end
Sequel::Model.db = DB = db
