class CreateStyles < ActiveRecord::Migration
  def up
    create_table :styles do |t|
      t.string :name
      t.text :description

      t.timestamps null: false
    end

    styles = Beer.all.map{|m| m.style}.uniq

    styles.each do |style|
      Style.create name:style, description:"EmptyDescription. Change this."
    end

    change_table :beers do |t|
      t.rename :style, :old_style
      t.belongs_to :style, index: true
    end

    #DO THIS IN CONSOLE
    #allBeers = Beer.all
    #allBeers.each do |beer|
    #  beer.style_id = Style.all.select{|s| s.name == beer.old_style}.first.id
    #end

    #change_table :beers do |t|
    #  t.remove :old_style
    #end
  end

  def down

  end
end