class ActsAsTrackableMigration < ActiveRecord::Migration
  def change
    create_table :tracks, :force => true do |t|
      t.belongs_to :tracker, polymorphic: true, :null => false, index: true
      t.belongs_to :trackable, polymorphic: true, :null => false, index: true
      t.string  :action, :null => false

      t.timestamps
    end
  end
end
