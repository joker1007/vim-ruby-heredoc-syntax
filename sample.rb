js = <<JS
  var i = 1;
  function(n) {
    alert(n);
  }
  json = {
    "key" : "val"
  };
JS

puts js

coffee = <<-COFFEE
  obj =
    name: "Hoge"

    putsName: -> ()
      console.log(@name)
COFFEE

puts coffee

sql = <<SQL
  select * from tables where id = 1
SQL

puts sql

html = <<HTML
  <html>
    <a href="#">link</a>
  </html>
HTML

puts html

normal = <<EOL
normal here doc
EOL

puts normal

class MyClass
  attr_accessor :name
end
