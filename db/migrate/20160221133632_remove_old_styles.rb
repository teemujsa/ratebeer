class RemoveOldStyles < ActiveRecord::Migration
  def up

    #DID THIS IN CONSOLE
    allBeers = Beer.all
    allBeers.each do |beer|
      beer.style = Style.all.select{|s| s.name == beer.old_style}.first
      beer.save
    end

    change_table :beers do |t|
      t.remove :old_style
    end
  end
end